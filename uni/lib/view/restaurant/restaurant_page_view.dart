import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    final weekDay = DateTime.now().weekday;
    super.initState();
    tabController = TabController(vsync: this, length: DayOfWeek.values.length);
    tabController.animateTo(tabController.index + (weekDay - 1));
    scrollViewController = ScrollController();
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navRestaurants.route);

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: createTabs(context),
        ),
        LazyConsumer<RestaurantProvider, List<Restaurant>>(
          builder: (context, restaurants) => createTabViewBuilder(
            restaurants,
            context,
          ),
          onNullContent: Center(
            child: Text(
              S.of(context).no_menus,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          hasContent: (restaurants) => restaurants.isNotEmpty,
        ),
      ],
    );
  }

  Widget createTabViewBuilder(
    List<Restaurant> restaurants,
    BuildContext context,
  ) {
    final dayContents = DayOfWeek.values.map((dayOfWeek) {
      final restaurantsWidgets = restaurants
          .where((element) => element.meals[dayOfWeek]?.isNotEmpty ?? false)
          .map(
            (restaurant) => createRestaurant(context, restaurant, dayOfWeek),
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
      return ListView(padding: EdgeInsets.zero, children: restaurantsWidgets);
    }).toList();

    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: dayContents,
      ),
    );
  }

  List<Widget> createTabs(BuildContext context) {
    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final tabs = <Widget>[];
    for (var i = 0; i < DayOfWeek.values.length; i++) {
      tabs.add(
        Tab(
          key: Key('cantine-page-tab-$i'),
          text: daysOfTheWeek[i],
        ),
      );
    }
    return tabs;
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
        .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text(S.of(context).no_menu_info)),
          ],
        ),
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
    return Provider.of<RestaurantProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
