import 'dart:html';

import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';

import 'package:uni/view/Widgets/cantine_slot.dart';

import 'package:uni/model/entities/restaurant.dart';

class CantinePageView extends StatelessWidget {
  CantinePageView({
    Key key,
    @required this.tabController,
    @required this.daysOfTheWeek,
    @required this.aggRestaurant,
    @required this.cantineStatus,
    this.scrollViewController
  });

  final List<String> daysOfTheWeek;
  final List<Restaurant> aggRestaurant;
  final RequestStatus cantineStatus;
  final TabController tabController;
  final ScrollController scrollViewController;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column (children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: 'Cantinas'),
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: createTabs(queryData, context),
          ),
        ],
      ),
      
      Expanded(
          child: TabBarView(
            controller: tabController,
            children: createCantine(context),
          ))
    ]);
  }

  List<Widget> createTabs(queryData, BuildContext context){
    final List<Widget> tabs = <Widget>[];

    for (var i = 0; i < daysOfTheWeek.length; i++){
      tabs.add(Container(color: Theme.of(context).backgroundColor,
      width: queryData.size.width * 1/3,
      child: Tab(key: Key('cantine-page-tab-$i'), text: daysOfTheWeek[i]),
      ));
    }

    return tabs;
  }

  List<Widget> createCantine(context){
    final List<Widget> tabBarViewContent = <Widget>[];

    for (var i = 0; i < daysOfTheWeek.length; i++){
      tabBarViewContent.add(createCantineByDay(context, i));
    }

    return tabBarViewContent;
  }

  List<Widget> createCantineRows(restaurants, BuildContext context){
    final List<Widget> cantineContent = <Widget>[];

    for (int i = 0; i < restaurants.lenght; i++){
      final Restaurant restaurant = restaurants[i];
      cantineContent.add(CantineSlot( //para cada dia, percorre a lista de meals
        
      ));
    }
    return cantineContent;
  }

  Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(int day){
    Widget createDayColumn(dayContent, BuildContext context){
      return Container(
        key: Key('cantine-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createCantineRows(dayContent, context),
        ));
    }

    return createDayColumn;
  }

  Widget createCantineByDay(BuildContext context, int day){
    return RequestDependentWidgetBuilder(
      context: context,
      status: cantineStatus,
      contentGenerator: dayColumnBuilder(day),
      content: aggRestaurant[day],
      //contentChecker: aggRestaurant[day].isNotEmpty,
      onNullContent: Center(child: Text('Não há refeições disponíveis.')),
      index: day,
    );
  }
}