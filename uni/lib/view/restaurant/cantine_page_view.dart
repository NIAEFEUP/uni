import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/model/utils/day_of_week.dart';

import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/restaurant/widgets/cantine_slot.dart';

class CantinePageView extends StatefulWidget {
  const CantinePageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CantinePageState();
}

class _CantinePageState extends GeneralPageViewState<CantinePageView>
    with SingleTickerProviderStateMixin {

  final List<DayOfWeek> daysOfTheWeek = [
    DayOfWeek.monday,
    DayOfWeek.tuesday,
    DayOfWeek.wednesday,
    DayOfWeek.thursday,
    DayOfWeek.friday,
    DayOfWeek.saturday,
    DayOfWeek.sunday
  ];

  late List<Restaurant> aggRestaurant;
  late TabController tabController;
  late ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    final int weekDay = DateTime.now().weekday;
    super.initState();
    tabController = TabController(vsync: this, length: daysOfTheWeek.length);
    final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
    scrollViewController = ScrollController();
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Restaurant>, RequestStatus?>>(
        converter: (store) {
          return Tuple2(store.state.content['restaurants'],
              store.state.content['restaurantsStatus']);
        },
        builder: (context, restaurantsInfo) =>
            _getPageView(restaurantsInfo.item1, restaurantsInfo.item2));

  }

  Widget _getPageView(List<Restaurant> restaurants, RequestStatus? status) {
    if (status == null) {
      return const Text("Estado do request inválido");
    }
    return Column(children: [
      ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          alignment: Alignment.center,
          child: const PageTitle(name: 'Ementas', center: false, pad: false),
        ),
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: createTabs(context),
        ),
      ]),
      RequestDependentWidgetBuilder(
          context: context,
          status: status,
          contentGenerator: createTabViewBuilder(),
          content: restaurants,
          contentChecker: restaurants.isNotEmpty,
          onNullContent: const Center(child: Text('Não há refeições disponíveis.')))
    ]);
  }

  Widget Function(dynamic restaurants, BuildContext) createTabViewBuilder() {
    Widget createTabView(dynamic restaurants, BuildContext context) {
      final List<Widget> dayContents =  daysOfTheWeek.map((dayOfWeek) {
        List<Widget> cantinesWidgets = [];
        if (restaurants is List<Restaurant>) {
          cantinesWidgets = restaurants
              .map((restaurant) => createCantine(context, restaurant, dayOfWeek))
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

    return createTabView;
  }

  List<Widget> createTabs(BuildContext context) {
    final List<Widget> tabs = <Widget>[];

    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        child: Tab(key: Key('cantine-page-tab-$i'), text: toString(daysOfTheWeek[i])),
      ));
    }

    return tabs;
  }

  Widget createCantine(context, Restaurant restaurant, DayOfWeek dayOfWeek) {
      return Column(
          mainAxisSize: MainAxisSize.min,

          children: [
        const SizedBox(height: 18,),
        Card(
          elevation: 2,
            child: Padding(padding: const EdgeInsets.all(14), child: Column(
        children: [
          Text(restaurant.name, style: Theme.of(context).textTheme.headline6,),
          createCantineByDay(context, restaurant, dayOfWeek),
        ],
      )
      ))]
      );
  }

  List<Widget> createCantineRows(List<Meal> meals, BuildContext context) {
    return meals
        .map((meal) => CantineSlot(type: meal.type, name: meal.name))
        .toList();
  }

  Widget createCantineByDay(
      BuildContext context, Restaurant restaurant, DayOfWeek day) {
    final List<Meal> meals = restaurant.getMealsOfDay(day);
    if (meals.isEmpty) {
      return Container(
          margin:
          const EdgeInsets.only(top: 20, bottom: 7),
          padding: const EdgeInsets.only(
              left: 44.0, right: 44.0),
          key: Key('cantine-page-day-column-$day'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            const [Text("Não há informação disponível sobre refeições"),],


          )
      );
    }

    else {
      return Container(
        margin:
          const EdgeInsets.only(top: 20, bottom: 7),
        key: Key('cantine-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createCantineRows(meals, context),

        )
    );
    }
  }
}
