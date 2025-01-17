import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/widgets/restaurant_page_card.dart';
import 'package:uni/view/restaurant/widgets/restaurant_slot.dart';
import 'package:uni_ui/cards/restaurant_card.dart' as cards;
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

import '../../controller/local_storage/preferences_controller.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantPageViewState();
}

class _RestaurantPageViewState extends GeneralPageViewState<RestaurantPageView>
    with SingleTickerProviderStateMixin {
  late List<Restaurant> aggRestaurant;
  late List<String> favoriteRestaurants;
  late TabController tabController;
  late ScrollController scrollViewController;
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];
  String? _selectedItem;
  late bool isFavoriteFilterOn;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: DayOfWeek.values.length);
    tabController
      ..addListener(() {
        setState(() {});
      })
      ..animateTo(1);
    scrollViewController = ScrollController();
    aggRestaurant = []; // Initialize the list
    _initializeRestaurants();
    favoriteRestaurants = PreferencesController.getFavoriteRestaurants();
    isFavoriteFilterOn = false;
  }

  void _toggleFavorite(String key) {
    setState(() {
      favoriteRestaurants.contains(key) ? favoriteRestaurants.remove(key) : favoriteRestaurants.add(key);
    });
  }

  Future<void> _initializeRestaurants() async {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    await restaurantProvider.ensureInitialized(context);
    if (restaurantProvider.state != null) {
      setState(() {
        aggRestaurant = List.from(restaurantProvider.state!); // Clone the list
        print(aggRestaurant as String);
      });
    }
  }

  List<Restaurant> getFavoriteRestaurants() {
    return aggRestaurant.where((restaurant) => favoriteRestaurants.contains(restaurant.namePt + restaurant.period)).toList();
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
          TabBar(
            controller: tabController,
            isScrollable: true,
            padding: EdgeInsets.zero,
            indicator: const BoxDecoration(),
            labelPadding: const EdgeInsets.symmetric(horizontal: 3),
            tabAlignment: TabAlignment.center,
            tabs: createTabs(context),
            dividerHeight: 0,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 245, 243, 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    child: DropdownButton<String>(
                      hint: const Text(
                        'Todos os pratos',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color.fromRGBO(127, 127, 127, 1)),
                      ),
                      underline: const SizedBox(),
                      isDense: true,
                      iconEnabledColor: const Color.fromRGBO(127, 127, 127, 1),
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: const Color.fromRGBO(255, 245, 243, 1),
                      value: _selectedItem,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedItem = newValue;
                        });
                      },
                      items: _items.map<DropdownMenuItem<String>>((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(127, 127, 127, 1),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isFavoriteFilterOn = !isFavoriteFilterOn;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: const Color.fromRGBO(
                        255, 245, 243, 1), // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded edges
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Favoritos',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(127, 127, 127, 1)),
                      ),
                      const SizedBox(width: 8), // Space between text and icon
                      if (!isFavoriteFilterOn)
                      Icon(
                        PhosphorIconsRegular.heart,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      )
                      else
                        Icon(
                          PhosphorIconsFill.heart,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                    ],
                  ),
                ),
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
    final weekDay = DateTime.now().weekday;
    final reorderedDays = [
      DayOfWeek.values[(weekDay - 2 + 7) % 7],
      ...DayOfWeek.values.skip(weekDay - 1),
      ...DayOfWeek.values.take(weekDay - 2)
    ];

    final dayContents = reorderedDays.map((dayOfWeek) {
      final restaurantsWidgets = restaurants
          .where((element) => element.meals[dayOfWeek]?.isNotEmpty ?? false)
          .map(
            (restaurant) => createNewRestaurant(context, restaurant, dayOfWeek),
          )
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

  List<Widget> createTabs(BuildContext context) {
    final weekDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final today = DateTime.now();

    // Reorder the daysOfTheWeek list
    final reorderedDays = [
      daysOfTheWeek[(weekDay - 2 + 7) % 7], // Previous day
      ...daysOfTheWeek.skip(weekDay - 1), // From today onwards
      ...daysOfTheWeek.take(weekDay - 2) // Remaining days from the start
    ];

    // Calculate the dates for the reordered days
    final reorderedDates = [
      today.subtract(const Duration(days: 1)), // Previous day
      ...List.generate(7, (i) => today.add(Duration(days: i)))
          .skip(0), // From today onwards
    ].take(7).toList();

    final tabs = <Widget>[];
    for (var i = 0; i < reorderedDays.length; i++) {
      tabs.add(
        Tab(
          key: Key('cantine-page-tab-$i'),
          height: 50,
          child: AnimatedBuilder(
            animation: tabController,
            builder: (context, child) {
              final isSelected = tabController.index == i;

              return Container(
                width: 45,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromRGBO(177, 77, 84, 0.25)
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toShortVersion(reorderedDays[i]),
                      style: isSelected
                          ? const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(102, 9, 16, 1))
                          : const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(48, 48, 48, 1)),
                    ),
                    Text(
                      '${reorderedDates[i].day}',
                      style: isSelected
                          ? const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(102, 9, 16, 1))
                          : const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(48, 48, 48, 1)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
    return tabs;
  }

  String toShortVersion(String dayOfTheWeek) {
    String shortVersion;
    switch (dayOfTheWeek) {
      case 'Monday':
        shortVersion = 'Mon';
      case 'Tuesday':
        shortVersion = 'Tue';
      case 'Wednesday':
        shortVersion = 'Wed';
      case 'Thursday':
        shortVersion = 'Thu';
      case 'Friday':
        shortVersion = 'Fri';
      case 'Saturday':
        shortVersion = 'Sat';
      case 'Sunday':
        shortVersion = 'Sun';
      default:
        shortVersion = 'Blank';
    }
    return shortVersion;
  }

  Widget createNewRestaurant(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek dayOfWeek,
  ) {
    final menuItems = getRestaurantMenuItems(dayOfWeek, restaurant) ?? [];
    return cards.RestaurantCard(
        name: restaurant.nameEn,
        icon: getRestaurantIcon(restaurant.typeEn ?? restaurant.typePt),
        isFavorite: favoriteRestaurants.contains(restaurant.namePt + restaurant.period),
        onFavoriteToggle: () => {_toggleFavorite(restaurant.namePt + restaurant.period)},
        menuItems: menuItems,);
  }

  Icon getRestaurantIcon(String? restaurantType) {
    return const PhosphorIcon(PhosphorIconsDuotone.cookingPot);
  }

  List<RestaurantMenuItem>? getRestaurantMenuItems(
      DayOfWeek dayOfWeek, Restaurant restaurant) {
    final meals = restaurant.meals[dayOfWeek];
    final menuItems = <RestaurantMenuItem>[];
    for (final meal in meals!) {
      menuItems.add(
          RestaurantMenuItem(name: meal.nameEn, icon: getMealIcon(meal.type)));
    }
    return menuItems;
  }

  Icon getMealIcon(String? mealType) {
    return const PhosphorIcon(PhosphorIconsDuotone.cow);
  }

  Widget createRestaurant(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek dayOfWeek,
  ) {
    return RestaurantPageCard(
      restaurant,
      createRestaurantByDay(context, restaurant, dayOfWeek),
    );
  }

  List<Widget> createRestaurantRows(List<Meal> meals, BuildContext context) {
    return meals
        .map(
          (meal) => RestaurantSlot(
            type: meal.type,
            namePt: meal.namePt,
            nameEn: meal.nameEn,
          ),
        )
        .toList();
  }

  Widget createRestaurantByDay(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek day,
  ) {
    final meals = restaurant.getMealsOfDay(day);
    if (meals.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        key: Key('restaurant-page-day-column-$day'),
        child: Center(child: Text(S.of(context).no_menu_info)),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        key: Key('restaurant-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createRestaurantRows(meals, context),
        ),
      );
    }
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    if (restaurantProvider.state != null) {
      setState(() {
        aggRestaurant = List.from(restaurantProvider.state!); // Clone the list
        print(aggRestaurant as String);
      });
    }
    return restaurantProvider.forceRefresh(context);
  }
}
