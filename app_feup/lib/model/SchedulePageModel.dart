import 'package:app_feup/view/Pages/SchedulePageView.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget{

  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{

  TabController tabController;

  final List<String> daysOfTheWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  final int weekDay = new DateTime.now().weekday;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: daysOfTheWeek.length);
    var offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new SchedulePageView(tabController: tabController, daysOfTheWeek: daysOfTheWeek);
  }
}