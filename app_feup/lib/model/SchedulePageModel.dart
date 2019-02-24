import 'package:app_feup/view/Pages/SchedulePageView.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget{
  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{

  final daysOfTheWeek = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-feira'
  ];

  @override
  Widget build(BuildContext context) {
    return new SchedulePageView(daysOfTheWeek: daysOfTheWeek);
  }
}