import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/widgets/days_of_week_tab_bar.dart';
import 'package:uni/view/restaurant/widgets/dish_type_dropdown_menu.dart';
import 'package:uni/view/restaurant/widgets/favorite_restaurants_button.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantPageViewState();
}

class _RestaurantPageViewState extends GeneralPageViewState<RestaurantPageView>
    with SingleTickerProviderStateMixin {
  late List<Restaurant> restaurants;
  late List<Restaurant> filteredRestaurants;
  late TabController tabController;
  late ScrollController scrollViewController;
  final List<Map<String, dynamic>> dishTypes = [
    {'value': 1, 'key_label': 'all_dishes'},
    {'value': 2, 'key_label': 'meat_dishes'},
    {'value': 3, 'key_label': 'fish_dishes'},
    {'value': 4, 'key_label': 'vegetarian_dishes'},
    {'value': 5, 'key_label': 'soups'},
    {'value': 6, 'key_label': 'salads'},
    {'value': 7, 'key_label': 'diet_dishes'},
    {'value': 8, 'key_label': 'dishes_of_the_day'},
  ];
  int? _selectedDishType;
  late bool isFavoriteFilterOn;

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
    restaurants = []; // Initialize the list
    filteredRestaurants = [];
    _initializeRestaurants();
    isFavoriteFilterOn =
        PreferencesController.getIsFavoriteRestaurantsFilterOn() ?? false;
    _selectedDishType = PreferencesController.getSelectedDishType() ?? 1;
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
        !favoriteCardTypes.contains(FavoriteWidgetType.restaurants)) {
      showRestaurantCardHomeDialog(
        context,
        favoriteCardTypes,
        PreferencesController.saveFavoriteCards,
      );
    }

    Restaurant? restaurantToRemove;
    if (isFavoriteFilterOn) {
      for (final restaurant in filteredRestaurants) {
        if ((restaurant.namePt == restaurantName ||
                restaurant.nameEn == restaurantName) &&
            restaurant.period == restaurantPeriod) {
          restaurantToRemove = restaurant;
          break;
        }
      }
      if (restaurantToRemove != null) {
        final currentScrollPosition = scrollViewController.position.pixels;

        setState(() {
          filteredRestaurants.remove(restaurantToRemove);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollViewController.jumpTo(currentScrollPosition);
        });
      }
    }
  }

  Future<void> _initializeRestaurants() async {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    await restaurantProvider.ensureInitialized(context);
    if (restaurantProvider.state != null) {
      setState(() {
        restaurants = List.from(restaurantProvider.state!);
        filteredRestaurants = restaurants;
      });
    }
  }

  void applyFavouriteRestaurantFilter() {
    filteredRestaurants = restaurants
        .where(
          (restaurant) => PreferencesController.getFavoriteRestaurants()
              .contains(restaurant.namePt + restaurant.period),
        )
        .toList();
  }

  Widget getFilteredContent(BuildContext context) {
    if (isFavoriteFilterOn) {
      applyFavouriteRestaurantFilter();
    } else {
      filteredRestaurants = restaurants;
    }

    return createTabViewBuilder(context);
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollViewController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navRestaurants.route);

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
                DishTypeDropdownMenu(
                  items: dishTypes,
                  selectedValue: _selectedDishType,
                  onChange: (newValue) {
                    setState(() {
                      PreferencesController.setSelectedDishType(newValue);
                      _selectedDishType = newValue;
                    });
                  },
                ),
                const SizedBox(width: 10),
                FavoriteRestaurantsButton(
                  isFavoriteOn: isFavoriteFilterOn,
                  onToggle: () => {
                    setState(() {
                      PreferencesController.setIsFavoriteRestaurantsFilterOn(
                        !isFavoriteFilterOn,
                      );
                      isFavoriteFilterOn = !isFavoriteFilterOn;
                    }),
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
      builder: (context, _) => getFilteredContent(context),
      onNullContent: Center(
        child: Text(
          S.of(context).no_menus,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      hasContent: (restaurants) => restaurants.isNotEmpty,
    );
  }

  Widget createTabViewBuilder(
    BuildContext context,
  ) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();

    const daysOfTheWeek = DayOfWeek.values;

    final dayContents = daysOfTheWeek.map((dayOfWeek) {
      final restaurantsWidgets = filteredRestaurants
          .where((element) => element.meals[dayOfWeek]?.isNotEmpty ?? false)
          .map(
            (restaurant) =>
                createNewRestaurant(context, restaurant, dayOfWeek, locale),
          )
          .where((widget) => widget != null)
          .toList();

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

    return TabBarView(
      controller: tabController,
      children: dayContents,
    );
  }

  RestaurantCard? createNewRestaurant(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek dayOfWeek,
    AppLocale locale,
  ) {
    final menuItems =
        getRestaurantMenuItems(dayOfWeek, restaurant, locale) ?? [];
    return menuItems.isNotEmpty
        ? RestaurantCard(
            name: RestaurantUtils.getRestaurantName(
              context,
              locale,
              restaurant.namePt,
              restaurant.namePt,
              restaurant.period,
            ),
            icon: RestaurantUtils.getIcon(
              restaurant.typeEn ?? restaurant.typePt,
            ),
            isFavorite: PreferencesController.getFavoriteRestaurants()
                .contains(restaurant.namePt + restaurant.period),
            onFavoriteToggle: () =>
                {_toggleFavorite(restaurant.namePt, restaurant.period)},
            menuItems: menuItems,
          )
        : null;
  }

  List<RestaurantMenuItem>? getRestaurantMenuItems(
    DayOfWeek dayOfWeek,
    Restaurant restaurant,
    AppLocale locale,
  ) {
    final meals = restaurant.meals[dayOfWeek];

    meals?.sort((a, b) => a.type.compareTo(b.type));

    final menuItems = <RestaurantMenuItem>[];
    for (final meal in meals!) {
      if (RestaurantUtils.mealMatchesFilter(_selectedDishType, meal.type)) {
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

  @override
  Future<void> onRefresh(BuildContext context) {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    if (restaurantProvider.state != null) {
      setState(() {
        restaurants = List.from(restaurantProvider.state!);
      });
    }
    return restaurantProvider.forceRefresh(context);
  }

  void showRestaurantCardHomeDialog(
    BuildContext context,
    List<FavoriteWidgetType> favoriteCardTypes,
    void Function(List<FavoriteWidgetType>) updateHomePage,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).restaurant_main_page),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
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
