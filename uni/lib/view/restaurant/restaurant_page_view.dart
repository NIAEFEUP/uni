import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/restaurant/widgets/restaurant_page_card.dart';
import 'package:uni/view/restaurant/widgets/restaurant_slot.dart';

class RestaurantPageView extends StatefulWidget {
  const RestaurantPageView({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends GeneralPageViewState<RestaurantPageView>
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
                  child: const PageTitle(
                    name: 'Ementas',
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
            RequestDependentWidgetBuilder(
              status: restaurantProvider.status,
              builder: () =>
                  createTabViewBuilder(restaurantProvider.restaurants, context),
              hasContentPredicate: restaurantProvider.restaurants.isNotEmpty,
              onNullContent:
                  const Center(child: Text('Não há refeições disponíveis.')),
            )
          ],
        );
      },
    );
  }

  Widget createTabViewBuilder(dynamic restaurants, BuildContext context) {
    final List<Widget> dayContents = DayOfWeek.values.map((dayOfWeek) {
      var restaurantsWidgets = <Widget>[];
      if (restaurants is List<Restaurant>) {
        restaurantsWidgets = restaurants
            .map(
              (restaurant) => RestaurantPageCard(
                restaurant.name,
                RestaurantDay(restaurant: restaurant, day: dayOfWeek),
              ),
            )
            .toList();
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
    final tabs = <Widget>[];

    for (var i = 0; i < DayOfWeek.values.length; i++) {
      tabs.add(
        Tab(
          key: Key('cantine-page-tab-$i'),
          text: toString(DayOfWeek.values[i]),
        ),
      );
    }

    return tabs;
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<RestaurantProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

class RestaurantDay extends StatelessWidget {
  const RestaurantDay({required this.restaurant, required this.day, super.key});
  final Restaurant restaurant;
  final DayOfWeek day;

  @override
  Widget build(BuildContext context) {
    final meals = restaurant.getMealsOfDay(day);
    if (meals.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        key: Key('restaurant-page-day-column-$day'),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text('Não há informação disponível sobre refeições'),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        key: Key('restaurant-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: meals
              .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
              .toList(),
        ),
      );
    }
  }
}
