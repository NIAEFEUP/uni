//import 'package:tuple/tuple.dart';
//import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/cantine_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/view/Widgets/page_title.dart';

import 'package:uni/model/utils/day_of_week.dart';

import 'app_state.dart';

class CantinePage extends StatefulWidget {
  const CantinePage({Key key}) : super(key : key);

  @override
  _CantinePageState createState() => _CantinePageState();
}

class _CantinePageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  final int weekDay = DateTime
      .now()
      .weekday;

  TabController tabController;
  ScrollController scrollViewController;

  final List<String> daysOfTheWeek = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira"
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: daysOfTheWeek.length);
    final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    var datetime = DateTime.parse("2022-10-12");
    var datetime2 = DateTime.parse("2022-10-13");

    var meal1 = Meal("Carne", "Peru assado", DayOfWeek.monday, datetime);
    var meal2 = Meal("Peixe", "Pescada cozida", DayOfWeek.monday, datetime);
    var meal4 = Meal("Carne", "Arroz de pato", DayOfWeek.monday, datetime);
    var meal5 = Meal("Peixe", "Peixe frito", DayOfWeek.monday, datetime);

    var meal6 = Meal("Carne", "Frango", DayOfWeek.tuesday, datetime2);
    var meal7 = Meal("Peixe", "Salmao", DayOfWeek.tuesday, datetime2);

    List<Meal> meals_list1 = [meal1, meal2, meal6, meal7];
    List<Meal> meals_list2 = [meal4, meal5];

    var rest1 = Restaurant(1, "FEUP", "", meals: meals_list1);
    var rest2 = Restaurant(2, "Bar de Minas", "", meals: meals_list2);

    List<Restaurant> rest = [rest1, rest2];
    RequestStatus cantineStatus;

    return CantinePageView(
        tabController: tabController,
        scrollViewController: scrollViewController,
        daysOfTheWeek: daysOfTheWeek,
        aggRestaurant: rest,
        cantineStatus: cantineStatus);
  }
}