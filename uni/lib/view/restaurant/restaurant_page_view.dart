import 'package:provider/provider.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/generated/l10n.dart';

import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/restaurant/widgets/restaurant_page_card.dart';
import 'package:uni/view/restaurant/widgets/restaurant_slot.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CanteenPageState();
}

class _CanteenPageState extends GeneralPageViewState<RestaurantPageView>
    with SingleTickerProviderStateMixin {
  late List<Restaurant> aggRestaurant;
  late TabController tabController;
  late ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    final int weekDay = DateTime.now().weekday;
    super.initState();
    tabController = TabController(vsync: this, length: DayOfWeek.values.length);
    tabController.animateTo((tabController.index + (weekDay-1)));
    scrollViewController = ScrollController();
  }

  @override
  Widget getBody(BuildContext context) {
    return Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, _) =>
            _getPageView(restaurantProvider.restaurants, restaurantProvider.status));

  }

   Widget _getPageView(List<Restaurant> restaurants, RequestStatus? status) {
    return Column(children: [
      ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          alignment: Alignment.center,
          child: PageTitle(name: S.of(context).menus , center: false, pad: false),
        ),
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: createTabs(context),
        ),
      ]),
      const SizedBox(height: 10),
      RequestDependentWidgetBuilder(
          context: context,
          status: status ?? RequestStatus.none,
          contentGenerator: createTabViewBuilder,
          content: restaurants,
          contentChecker: restaurants.isNotEmpty,
          onNullContent: Center(child: Text(S.of(context).no_menus)))
    ]);
  }

  Widget createTabViewBuilder(dynamic restaurants, BuildContext context) {
      final List<Widget> dayContents =  DayOfWeek.values.map((dayOfWeek) {
        List<Widget> cantinesWidgets = [];
        if (restaurants is List<Restaurant>) {
          cantinesWidgets = restaurants
              .map((restaurant) => createRestaurant(context, restaurant, dayOfWeek))
              .toList();
        }
        return ListView( children: cantinesWidgets,);
      }).toList();

      return Expanded(
          child: TabBarView(
        controller: tabController,
        children: dayContents,
      ));
  }

  List<Widget> createTabs(BuildContext context) {
    final List<String> daysOfTheWeek =
      TimeString.getWeekdaysStrings(includeWeekend: true);
    final List<Widget> tabs = <Widget>[];

    for (var i = 0; i < DayOfWeek.values.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        child: Tab(key: Key('cantine-page-tab-$i'), text: daysOfTheWeek[i]),
      ));
    }

    return tabs;
  }

  Widget createRestaurant(context, Restaurant restaurant, DayOfWeek dayOfWeek) {
    return RestaurantPageCard(restaurant.name, createRestaurantByDay(context, restaurant, dayOfWeek));
  }

  List<Widget> createRestaurantRows(List<Meal> meals, BuildContext context) {
    return meals
        .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
        .toList();
  }

  Widget createRestaurantByDay(
      BuildContext context, Restaurant restaurant, DayOfWeek day) {
    final List<Meal> meals = restaurant.getMealsOfDay(day);
    if (meals.isEmpty) {
      return Container(
          margin:
          const EdgeInsets.only(top: 10, bottom: 5),
          key: Key('cantine-page-day-column-$day'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Center (child: Text(S.of(context).no_menu_info)),],
          )
      );
    } else {
      return Container(
        margin:
          const EdgeInsets.only(top: 5, bottom: 5),
        key: Key('cantine-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createRestaurantRows(meals, context),
        )
    );
    }
  }
}
