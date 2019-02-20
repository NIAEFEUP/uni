import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/widgets/ScheduleRow.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final double borderRadius = 12.0;
  final double leftPadding = 12.0;

  ScheduleCard(
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
        converter: (store) => store.state.content['schedule'],
        builder: (context, lectures){
          if(lectures.length >= 2) {
            return Container(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: this.getScheduleRows(context, lectures),
                )
            );
          } else {
            return Center(child: Text("No lectures or classes to show at the moment"));
          }
        }
    );
  }

  List<Widget> getScheduleRows(context, lectures){
    List<Widget> rows = new List<Widget>();
    for(int i = 0; i < 2 && i < lectures.length; i++){
      rows.add(this.createRowFromLecture(context, lectures[i]));
    }
    return rows;
  }

  Widget createRowFromLecture(context, lecture){
    return new ScheduleRow(
      subject: lecture.subject,
      rooms: lecture.room,
      begin: lecture.startTime,
      end: lecture.endTime,
      teacher: lecture.teacher,
    );
  }
}
