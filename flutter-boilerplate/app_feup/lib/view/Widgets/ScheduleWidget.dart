import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:flutter/material.dart';

class ScheduleWidget extends StatelessWidget {
  ScheduleWidget({Key key,
    @required this.title,
              this.widget}) : super(key: key);

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      height: 250,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 0xeb, 0xeb, 0xeb),
          border: Border.all(color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: new Column(
        children: <Widget>[
          new Container(
            child: Text(title,
                style: TextStyle(color: Color.fromARGB(255, 0x8C, 0x2D, 0x19))),
            height: 30,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(38, 0, 0, 0),
          ),
          new Expanded(
            child: new Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: new Container(
                                // widget here
              ),
            ),
          )
        ],
      ),
    );
  }
}
//
//class ScheduleWidgetState extends State<ScheduleWidget> {
//  List<Lecture> lecturesList = new List();
//  Lecture lec1 = new Lecture();
//  Lecture lec2 = new Lecture();
//
//  //this is an action - it processes a state change
//  void functionToProcessAStateChange() {
//    setState(() {
//      lec1.subject = 'SOPE';
//      lec1.typeClass = 'TE';
//      lec1.day = 1;
//      lec1.blocks = 4;
//      lec1.startTime = "14:00";
//      lec2.subject = 'BDAD';
//      lec2.typeClass = 'TP';
//      lec2.day = 1;
//      lec2.blocks = 2;
//      lec2.startTime = "17:00";
//      lecturesList.add(lec1);
//      lecturesList.add(lec2);
//    });
//  }
//
//
//}
