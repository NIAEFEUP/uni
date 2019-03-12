import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/SchedulePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SchedulePage extends StatefulWidget{

  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{

  TabController tabController;

  List<List<Lecture>> aggLectures;

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

  void _groupLecturesByDay(schedule) {

    aggLectures = new List<List<Lecture>>();

    for(int i = 0; i < daysOfTheWeek.length; i++) {
      List<Lecture> lectures = List<Lecture>();
      for(int j = 0; j < schedule.length; j++){
        if(schedule[j].day == i)
          lectures.add(schedule[j]);
      }
      aggLectures.add(lectures);
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Lecture> schedule = StoreProvider.of<AppState>(context).state.content['schedule'];
    _groupLecturesByDay(schedule);

    return new SchedulePageView(tabController: tabController, daysOfTheWeek: daysOfTheWeek, aggLectures: aggLectures);
  }
}