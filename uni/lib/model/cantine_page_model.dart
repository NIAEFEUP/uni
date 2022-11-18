//import 'package:tuple/tuple.dart';
//import 'package:uni/model/app_state.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_redux/flutter_redux.dart';

import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';

import 'package:uni/model/entities/restaurant.dart';

import '../view/cantine_page_view.dart';
import 'app_state.dart';
//import 'package:uni/view/Widgets/page_title.dart';

class CantinePage extends StatefulWidget {
  const CantinePage({Key? key}) : super(key: key);
  @override
  _CantinePageState createState() => _CantinePageState();
}

class _CantinePageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  final int weekDay = DateTime.now().weekday;

  late TabController tabController;
  late ScrollController scrollViewController;

  final List<String> daysOfTheWeek = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira"
  ];

  //POR ENQUANTO IGNORAR A FUNCAO GROUP BY PORQUE NAO DEVE SER NECESSARIO

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: daysOfTheWeek.length);
    final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Restaurant>, RequestStatus>>(
        converter: (store) => Tuple2(
            store.state.content['restaurants'],
            RequestStatus
                .successful), // TODO:: store.state.content['cantineStatus']
        builder: (context, restaurantData) {
          final restaurants = restaurantData.item1;
          print("JDDJDJJDJDJDJDJDJJDJDJDJJDJDJDJDJDJDJDJDJDJ");
          print(restaurants);
          print("JDDJDJJDJDJDJDJDJJDJDJDJJDJDJDJDJDJDJDJDJDJ");

          final cantineStatus = restaurantData.item2;

          return CantinePageView(
              tabController: tabController,
              scrollViewController: scrollViewController,
              daysOfTheWeek: daysOfTheWeek,
              aggRestaurant: restaurants, // _groupMealsByDay(meals),
              cantineStatus: cantineStatus);
        });
  }
  /*
  @override
  Widget getBody(BuildContext context){
    return StoreConnector<AppState, Tuple2<List<Restaurant>, RequestStatus>>(
      converter: (store) => Tuple2(store.state.content['cantine']),
        store.state.content['cantineStatus']),
      builder: (context, restaurantData) {
        final restaurants = restaurantData.item1;
        final cantineStatus = restaurantData.item2;
        return CantinePageView(
            tabController: tabController,
            scrollViewController: scrollViewController,
            daysOfTheWeek: daysOfTheWeek;
            aggMeals: _groupMealsByDay(meals);
            cantineStatus: cantineStatus;
        )
      }
  } */
}
