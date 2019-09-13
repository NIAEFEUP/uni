import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:app_feup/view/Widgets/DateRectangle.dart';
import 'package:app_feup/view/Widgets/GenericCard.dart';
import 'package:app_feup/view/Widgets/ScheduleSlot.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Lecture> lectures = new List<Lecture>();

  ScheduleCard(
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
        converter: (store) => store.state.content['schedule'],
        builder: (context, lectures){
          return GenericCard(
              title: "Horário",
              func: () => Navigator.pushNamed(context, '/Horário'),
              child:
                getCardContent(context, this.lectures)
          );
        }
    );
  }
  
  Widget getCardContent(BuildContext context, lectures){
    switch (StoreProvider.of<AppState>(context).state.content['scheduleStatus']){
      case RequestStatus.SUCCESSFUL:
         return lectures.length >= 1 ?
          Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: getScheduleRows(context, lectures),
              ))
          : Center(
            child: Text("No lectures or classes to show at the moment", style: Theme.of(context).textTheme.display1)
          );
      case RequestStatus.BUSY:
        return Center(child: CircularProgressIndicator());
      case RequestStatus.FAILED:
        if(lectures.length != 0)
          return Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: getScheduleRows(context, lectures),
              )
          );
        else return Center(child: Text("Comunication error. Please check your internet connection."));
        break;
      default:
        return Container();
      } 
  }

  List<Widget> getScheduleRows(context, List<Lecture> lectures){

    if (lectures.length >= 2){  // In order to display lectures of the next week
      Lecture lecturefirstCycle = Lecture.clone(lectures[0]);
      lecturefirstCycle.day += 7;
      Lecture lecturesecondCycle = Lecture.clone(lectures[1]);
      lecturesecondCycle.day += 7;
      lectures.add(lecturefirstCycle);
      lectures.add(lecturesecondCycle);
    }
    List<Widget> rows = new List<Widget>();

    var now = new DateTime.now();
    var added = 0; // Lectures added to widget
    var lastDayAdded = 0; // Day of last added lecture
    var stringTimeNow = (now.weekday-1).toString().padLeft(2, '0') +
                        now.hour.toString().padLeft(2, '0') + ":" +
                        now.minute.toString().padLeft(2, '0');  // String with current time within the week

    for(int i = 0; added < 2 && i < lectures.length; i++){
      var stringEndTimeLecture = lectures[i].day.toString().padLeft(2, '0') + lectures[i].endTime; // String with end time of lecture

      if (stringTimeNow.compareTo(stringEndTimeLecture) < 0){

        if (now.weekday - 1 != lectures[i].day && lastDayAdded < lectures[i].day) // If it is a lecture from future days and no date title has been already added
          rows.add(new DateRectangle(date: Lecture.dayName[lectures[i].day % 7]));

        rows.add(createRowFromLecture(context, lectures[i]));
        lastDayAdded = lectures[i].day;
        added++;
      }
    }

    if (rows.length == 0){ // Edge case where there is only one lecture in the week and we already had it this week
      rows.add(new DateRectangle(date: Lecture.dayName[lectures[0].day % 7]));
      rows.add(createRowFromLecture(context, lectures[0]));
    }
    return rows;
  }

  Widget createRowFromLecture(context, lecture){
    return new Container (
        margin: EdgeInsets.only(bottom: 10),
        child: new ScheduleSlot(
          subject: lecture.subject,
          rooms: lecture.room,
          begin: lecture.startTime,
          end: lecture.endTime,
          teacher: lecture.teacher,
          typeClass: lecture.typeClass,
        )
    );
  }
}
