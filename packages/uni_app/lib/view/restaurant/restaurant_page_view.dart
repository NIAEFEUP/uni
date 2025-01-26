import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/restaurant/widgets/days_of_week_tab_bar.dart';
import 'package:uni/view/restaurant/widgets/dish_type_dropdown_menu.dart';
import 'package:uni/view/restaurant/widgets/favorite_restaurants_button.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

import '../../controller/local_storage/preferences_controller.dart';
import '../../utils/favorite_widget_type.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantPageViewState();
}

class _RestaurantPageViewState extends GeneralPageViewState<RestaurantPageView>
    with SingleTickerProviderStateMixin {
  late List<Restaurant> aggRestaurant;
  late TabController tabController;
  late ScrollController scrollViewController;
  final List<Map<String, dynamic>> _items = [
    {'value': 1, 'label': 'Todos os pratos'},
    {'value': 2, 'label': 'Pratos de Carne'},
    {'value': 3, 'label': 'Pratos de Peixe'},
    {'value': 4, 'label': 'Pratos Vegetarianos'},
    {'value': 5, 'label': 'Sopas'},
    {'value': 6, 'label': 'Saladas'},
    {'value': 7, 'label': 'Pratos de Dieta'},
  ];
  int? _selectedItem;
  late bool isFavoriteFilterOn;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: DayOfWeek.values.length);
    tabController
      ..addListener(() {
        setState(() {});
      })
      ..animateTo(DateTime.now().weekday % DateTime.sunday);
    scrollViewController = ScrollController();
    aggRestaurant = []; // Initialize the list
    _initializeRestaurants();
    isFavoriteFilterOn = false;
    _selectedItem = 1;
  }

  void _toggleFavorite(String key) {
    final favoriteRestaurants = PreferencesController.getFavoriteRestaurants();
    favoriteRestaurants.contains(key)
        ? favoriteRestaurants.remove(key)
        : favoriteRestaurants.add(key);
    PreferencesController.saveFavoriteRestaurants(favoriteRestaurants);

    final favoriteCardTypes = PreferencesController.getFavoriteCards();

    if (context.mounted &&
        !favoriteCardTypes.contains(FavoriteWidgetType.restaurant)) {
      showRestaurantCardHomeDialog(
        context,
        favoriteCardTypes,
        PreferencesController.saveFavoriteCards,
      );
    }
  }

  Future<void> _initializeRestaurants() async {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    await restaurantProvider.ensureInitialized(context);
    if (restaurantProvider.state != null) {
      setState(() {
        aggRestaurant = List.from(restaurantProvider.state!);
      });
    }
  }

  List<Restaurant> getFavoriteRestaurants() {
    return aggRestaurant
        .where((restaurant) => PreferencesController.getFavoriteRestaurants()
            .contains(restaurant.namePt + restaurant.period))
        .toList();
  }

  Widget getFilteredContent(BuildContext context) {
    List<Restaurant> filteredRestaurants;
    if (isFavoriteFilterOn) {
      filteredRestaurants = getFavoriteRestaurants();
    } else {
      filteredRestaurants = aggRestaurant;
    }

    return createTabViewBuilder(filteredRestaurants, context);
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
                    items: _items,
                    selectedValue: _selectedItem,
                    onChange: (newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    }),
                const SizedBox(width: 10),
                FavoriteRestaurantsButton(
                  isFavoriteOn: isFavoriteFilterOn,
                  onToggle: () => {
                    setState(() {
                      isFavoriteFilterOn = !isFavoriteFilterOn;
                    }),
                  },
                )
              ],
            ),
          )
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
          style: const TextStyle(fontSize: 18),
        ),
      ),
      hasContent: (restaurants) => restaurants.isNotEmpty,
    );
  }

  Widget createTabViewBuilder(
    List<Restaurant> restaurants,
    BuildContext context,
  ) {
    const daysOfTheWeek = DayOfWeek.values;

    final reorderedDays = List.generate(daysOfTheWeek.length,
        (i) => daysOfTheWeek[(i + DateTime.saturday) % DateTime.sunday]);

    final dayContents = reorderedDays.map((dayOfWeek) {
      final restaurantsWidgets = restaurants
          .where((element) => element.meals[dayOfWeek]?.isNotEmpty ?? false)
          .map((restaurant) =>
              createNewRestaurant(context, restaurant, dayOfWeek))
          .where((widget) => widget != null)
          .toList();

      if (restaurantsWidgets.isEmpty) {
        return Center(
          child: Text(
            S.of(context).no_menus,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }
      return ListView.separated(
        controller: scrollViewController,
        padding: const EdgeInsets.only(left: 20, right: 20),
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
  ) {
    final menuItems = getRestaurantMenuItems(dayOfWeek, restaurant) ?? [];
    return menuItems.isNotEmpty
        ? RestaurantCard(
            name: restaurant.nameEn,
            icon: RestaurantUtils.getIcon(
                restaurant.typeEn ?? restaurant.typePt!),
            isFavorite: PreferencesController.getFavoriteRestaurants()
                .contains(restaurant.namePt + restaurant.period),
            onFavoriteToggle: () =>
                {_toggleFavorite(restaurant.namePt + restaurant.period)},
            menuItems: menuItems,
          )
        : null;
  }

  List<RestaurantMenuItem>? getRestaurantMenuItems(
      DayOfWeek dayOfWeek, Restaurant restaurant) {
    final meals = restaurant.meals[dayOfWeek];
    final menuItems = <RestaurantMenuItem>[];
    for (final meal in meals!) {
      if (RestaurantUtils.mealMatchesFilter(_selectedItem, meal.type)) {
        menuItems.add(RestaurantMenuItem(
            name: meal.nameEn, icon: RestaurantUtils.getIcon(meal.type)));
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
        aggRestaurant = List.from(restaurantProvider.state!);
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
                favoriteCardTypes + [FavoriteWidgetType.restaurant],
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
