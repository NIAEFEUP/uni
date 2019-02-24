import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/widgets/NavigationDrawer.dart';
import 'package:app_feup/view/widgets/ScheduleRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SchedulePageView extends StatelessWidget {

  SchedulePageView(
      {Key key,
        @required this.tabController,
        @required this.daysOfTheWeek})
      : super(key: key);

  final List<String> daysOfTheWeek;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {

    final MediaQueryData queryData = MediaQuery.of(context);

    return new Scaffold(
        appBar: new AppBar(
            title: new Text("App FEUP"),
        ),
        drawer: new NavigationDrawer(),
        body:  new Column(
          children: <Widget>[
            new Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 150.0),
              child: new Material(
                color: Colors.white,
                child: new TabBar(
                  controller: tabController,
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.grey,
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.grey,
                  labelPadding: EdgeInsets.all(0.0),
                  tabs: createTabs(queryData),
                ),
              ),
            ),
            new Expanded(
              child: new TabBarView(
                controller: tabController,
                children: createSchedule(context),
              ),
            ),
          ],
        ),
      );
  }

  List<Widget> createTabs(queryData) {
    List<Widget> tabs = List<Widget>();
    for( var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(
          new Container(
            width:  queryData.size.width * 1/3,
            child: new Tab(text: daysOfTheWeek[i]),
          )
      );
    }
    return tabs;
  }

  List<Widget> createSchedule(context) {
    List<Widget> tabBarViewContent = List<Widget>();
    for(int i = 0; i < daysOfTheWeek.length; i++) {
      tabBarViewContent.add(createScheduleByDay(i));
    }
    return tabBarViewContent;
  }

  _getLecturesByDay(schedule, day) {
    List<Lecture> lectures = List<Lecture>();
    for(int i = 0; i < schedule.length; i++){
      if(schedule[i].day == day)
        lectures.add(schedule[i]);
    }
    return lectures;
  }

  List<Widget> createScheduleRows(lectures){
    List<Widget> scheduleContent = List<Widget>();
    for(int i = 0; i < lectures.length; i++) {
      Lecture lecture = lectures[i];
      scheduleContent.add(new ScheduleRow(
      subject: lecture.subject,
      rooms: lecture.room,
      begin: lecture.startTime,
      end: lecture.endTime,
      teacher: lecture.teacher,
      ));
    }
    return scheduleContent;
  }

  Widget createScheduleByDay(day) {
    return StoreConnector<AppState, List<dynamic>>(
        converter: (store) => store.state.content['schedule'],
        builder: (context, lectures){

          List<Lecture> aggLectures = _getLecturesByDay(lectures, day);

          if(aggLectures.length >= 1) {
            return Container(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: createScheduleRows(aggLectures),
                )
            );
          } else {
            return Center(child: Text("Não possui aulas à " + daysOfTheWeek[day] + "."));
          }
        }
    );
  }
}