import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/widgets/days_of_week_tab_bar.dart';
import 'package:uni/view/restaurant/widgets/dish_type_checkbox_menu.dart';
import 'package:uni/view/restaurant/widgets/favorite_restaurants_button.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantPageViewState();
}

class _RestaurantPageViewState extends GeneralPageViewState<RestaurantPageView>
    with SingleTickerProviderStateMixin {
  late List<Restaurant> restaurants;
  late TabController tabController;
  late ScrollController scrollViewController;

  // Filters
  late bool isFavoriteFilterOn;
  late int selectedCampus;
  late Set<String> _selectedDishTypes;

  final dishTypes = <String>[
    'meat_dishes',
    'fish_dishes',
    'vegetarian_dishes',
    'soups',
    'salads',
    'diet_dishes',
    'dishes_of_the_day',
		'closed',
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: DayOfWeek.values.length);
    tabController
      ..addListener(() {
        setState(() {});
      })
      ..animateTo(DateTime.now().weekday - 1);
    scrollViewController = ScrollController();

    restaurants = [];
    _initializeRestaurants();

    selectedCampus = PreferencesController.getSelectedCampus() ?? 0;

    isFavoriteFilterOn =
        PreferencesController.getIsFavoriteRestaurantsFilterOn() ?? false;

    _selectedDishTypes = PreferencesController.getSelectedDishTypes();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollViewController.dispose();
    super.dispose();
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );

    await restaurantProvider.forceRefresh(context);

    if (!mounted) {
      return;
    }

    if (restaurantProvider.state != null) {
      setState(() {
        restaurants = restaurantProvider.state!;
      });
    }
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navRestaurants.route);

  @override
  Widget? getRightContent(BuildContext context) {
    final campus = <String>[
      S.of(context).all,
      'Baixa da Cidade',
      'Asprela',
      'Campo Alegre',
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: campus[selectedCampus],
          elevation: 16,
          onChanged: (value) {
            setState(() {
              final campusId = campus.indexOf(value!);
              selectedCampus = campusId;
              PreferencesController.setSelectedCampus(campusId);
            });
          },
          items:
              campus.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
        ),
      ),
    );
  }

  @override
  Widget? getHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          DaysOfWeekTabBar(controller: tabController),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DishTypeCheckboxMenu(
                  items: dishTypes,
                  selectedValues: _selectedDishTypes,
                  onSelectionChanged: (newValues) {
                    setState(() {
                      _selectedDishTypes = newValues;
                      PreferencesController.setSelectedDishTypes(newValues);
                    });
                  },
                ),
                const SizedBox(width: 10),
                FavoriteRestaurantsButton(
                  isFavoriteOn: isFavoriteFilterOn,
                  onToggle: () {
                    setState(() {
                      PreferencesController.setIsFavoriteRestaurantsFilterOn(
                        !isFavoriteFilterOn,
                      );
                      isFavoriteFilterOn = !isFavoriteFilterOn;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<RestaurantProvider, List<Restaurant>>(
      builder: (context, _) => _createTabViewBuilder(context),
      onNullContent: Center(
        child: Text(
          S.of(context).no_menus,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      hasContent: (restaurants) => restaurants.isNotEmpty,
    );
  }

  Future<void> _initializeRestaurants() async {
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );
    await restaurantProvider.ensureInitialized(context);
    if (restaurantProvider.state != null) {
      setState(() {
        restaurants = restaurantProvider.state!;
      });
    }
  }

  void _toggleFavorite(String restaurantName, String restaurantPeriod) {
    final key = restaurantName + restaurantPeriod;
    final favoriteRestaurants = PreferencesController.getFavoriteRestaurants();
    favoriteRestaurants.contains(key)
        ? favoriteRestaurants.remove(key)
        : favoriteRestaurants.add(key);

    PreferencesController.saveFavoriteRestaurants(favoriteRestaurants);

    final favoriteCardTypes = PreferencesController.getFavoriteCards();

    if (context.mounted &&
        favoriteRestaurants.contains(key) &&
        !favoriteCardTypes.contains(FavoriteWidgetType.restaurants) &&
        !PreferencesController.isRestaurantReminderDismissed()) {
      _showRestaurantCardHomeDialog(
        context,
        favoriteCardTypes,
        PreferencesController.saveFavoriteCards,
      );
    }
  }

  Widget _createTabViewBuilder(BuildContext context) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();

    const daysOfTheWeek = DayOfWeek.values;

    final dayContents =
        daysOfTheWeek.map((dayOfWeek) {
          final restaurantsWidgets =
              restaurants
                  // Remove restaurants with no meals
                  .where((restaurant) {
                    return restaurant.meals.any(
                      (meal) => meal.dayOfWeek == dayOfWeek,
                    );
                  })
                  // Apply User filters
                  .where((restaurant) {
                    final isFavorite =
                        isFavoriteFilterOn &&
                        PreferencesController.getFavoriteRestaurants().contains(
                          restaurant.namePt + restaurant.period,
                        );

                    final isCampusMatch =
                        selectedCampus == 0 ||
                        restaurant.campusId == selectedCampus;

                    // Show Restaurant if it is in the selected campus and
                    // it either is a favorite (always show)
                    // or the favorite filter is off
                    return isCampusMatch && (isFavorite || !isFavoriteFilterOn);
                  })
                  .map((restaurant) {
                    return _createNewRestaurant(
                      context,
                      restaurant,
                      dayOfWeek,
                      locale,
                    );
                  })
                  .where((widget) => widget != null)
                  .toList()
                ..sort((a, b) {
                  final isAFavorite = a!.isFavorite ? 1 : 0;
                  final isBFavorite = b!.isFavorite ? 1 : 0;

                  return isBFavorite.compareTo(isAFavorite);
                });

          if (restaurantsWidgets.isEmpty) {
            return Center(
              child: Text(
                S.of(context).no_menus,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.separated(
            controller: scrollViewController,
            itemCount: restaurantsWidgets.length,
            itemBuilder: (context, index) {
              return restaurantsWidgets[index];
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
          );
        }).toList();

    return TabBarView(controller: tabController, children: dayContents);
  }

  RestaurantCard? _createNewRestaurant(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek dayOfWeek,
    AppLocale locale,
  ) {
    final menuItems =
        _getRestaurantMenuItems(dayOfWeek, restaurant, locale) ?? [];
    return menuItems.isNotEmpty
        ? RestaurantCard(
          name: RestaurantUtils.getRestaurantName(
            context,
            locale,
            restaurant.namePt,
            restaurant.namePt,
            restaurant.period,
          ),
          icon: RestaurantUtils.getIcon(restaurant.typeEn ?? restaurant.typePt),
          isFavorite: PreferencesController.getFavoriteRestaurants().contains(
            restaurant.namePt + restaurant.period,
          ),
          onFavoriteToggle: () {
            return _toggleFavorite(restaurant.namePt, restaurant.period);
          },
          menuItems: menuItems,
          onClick: () {
            if (restaurant.openingHours.isNotEmpty) {
              showDialog<ModalDialog>(
                context: context,
                builder: (context) {
                  return ModalDialog(
                    children: [
                      ModalServiceInfo(
                        name: restaurant.namePt,
                        durations:
                            restaurant.openingHours
                              ..sort((a, b) => a.compareTo(b)),
                      ),
                      if (restaurant.email != '')
                        ModalInfoRow(
                          title: S.of(context).email,
                          description: restaurant.email,
                          onPressed:
                              () => launchUrlWithToast(
                                context,
                                'mailto:${restaurant.email}',
                              ),
                          icon: UniIcons.email,
                          trailing: const UniIcon(UniIcons.caretRight),
                        ),
                    ],
                  );
                },
              );
            }
          },
        )
        : null;
  }

  List<RestaurantMenuItem>? _getRestaurantMenuItems(
    DayOfWeek dayOfWeek,
    Restaurant restaurant,
    AppLocale locale,
  ) {
    final meals = restaurant.getMealsOfDay(dayOfWeek)
      ..sort((a, b) => a.type.compareTo(b.type));

    final menuItems = <RestaurantMenuItem>[];
    for (final meal in meals) {
      if (RestaurantUtils.mealMatchesFilter(_selectedDishTypes, meal.type)) {
        menuItems.add(
          RestaurantMenuItem(
            name: RestaurantUtils.getLocaleTranslation(
              locale,
              meal.namePt,
              meal.nameEn,
            ),
            icon: RestaurantUtils.getIcon(meal.type),
          ),
        );
      }
    }

    return menuItems;
  }

  void _showRestaurantCardHomeDialog(
    BuildContext context,
    List<FavoriteWidgetType> favoriteCardTypes,
    void Function(List<FavoriteWidgetType>) updateHomePage,
  ) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).restaurant_main_page),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  PreferencesController.setRestaurantReminderDismissed(true);
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).no),
              ),
              ElevatedButton(
                onPressed: () {
                  updateHomePage(
                    favoriteCardTypes + [FavoriteWidgetType.restaurants],
                  );
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).yes),
              ),
            ],
          ),
    );
  }
}
