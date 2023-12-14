import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
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
  Widget getBody(BuildContext context) {
    return LazyConsumer<RestaurantProvider>(
      builder: (context, restaurantProvider) {
        return Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  alignment: Alignment.center,
                  child: PageTitle(
                    name: S
                        .of(context)
                        .nav_title(DrawerItem.navRestaurants.title),
                    center: false,
                    pad: false,
                  ),
                ),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabs: createTabs(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RequestDependentWidgetBuilder(
                status: restaurantProvider.requestStatus,
                builder: () => createTabViewBuilder(
                  restaurantProvider.state!,
                  context,
                ),
                hasContentPredicate: restaurantProvider.state!.isNotEmpty,
                onNullContent: Center(
                  child: Text(
                    S.of(context).no_menus,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
      return ListView(children: restaurantsWidgets);
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
        margin: const EdgeInsets.only(top: 10, bottom: 5),
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
