import 'package:app_feup/view/Pages/SchedulePageView.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget{

  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{

  TabController tabController;

  final daysOfTheWeek = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-feira'
  ];

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: daysOfTheWeek.length);
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