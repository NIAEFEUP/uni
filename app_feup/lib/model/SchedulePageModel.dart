import 'package:uni/model/AppState.dart';
import 'package:uni/model/entities/Lecture.dart';
import 'package:uni/view/Pages/SchedulePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SchedulePage extends StatefulWidget{

  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{

  TabController tabController;
  ScrollController scrollViewController;

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

  List<List<Lecture>> _groupLecturesByDay(schedule) {

    final aggLectures = new List<List<Lecture>>();

    for(int i = 0; i < daysOfTheWeek.length; i++) {
      List<Lecture> lectures = List<Lecture>();
      for(int j = 0; j < schedule.length; j++){
        if(schedule[j].day == i)
          lectures.add(schedule[j]);
      }
      aggLectures.add(lectures);
    }
    return aggLectures;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Lecture>>(
      converter: (store) => store.state.content['schedule'],
      builder: (context, lectures){
        return  new SchedulePageView(tabController: tabController, scrollViewController: scrollViewController, daysOfTheWeek: daysOfTheWeek, aggLectures: _groupLecturesByDay(lectures));
      },
    );
  }
}