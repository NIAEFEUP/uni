import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';

class ScheduleSlot extends StatelessWidget{
  final String subject;
  final String rooms;
  final String begin;
  final String end;
  final String teacher;
  final String typeClass;

  ScheduleSlot({
    Key key,
    @required this.subject,
    @required this.typeClass,
    @required this.rooms,
    @required this.begin,
    @required this.end,
    this.teacher

  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 2.0, color: divider))
          ),
          child: new Column (
            children: <Widget>[
              createScheduleSlotRow(0, context),
              createScheduleSlotRow(1, context),
              createScheduleSlotRow(2, context),
            ],
          )
        )
    );
  }

  List<Widget> getScheduleSlotRowContent(index, context) {
    List<Widget> content = List<Widget>();
    switch (index) {
      case 0:
        content.add(createScheduleSlotTime(context));
        break;
      case 1:
        content = (createScheduleSlotPrimInfo(context));
        break;
      case 2:
        content.add(createScheduleSlotTeacherInfo(context));
    }
    return content;
  }

  Widget createScheduleSlotRow(index, context) {

    List<Widget> rowContent = getScheduleSlotRowContent(index, context);

    return new Container (
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowContent,
        )
    );
  }

  Widget createScheduleSlotTime(context) {
    return createTextField(this.begin + " - " +  this.end, TextStyle(fontSize: 13.0,  color: Colors.black, fontWeight: FontWeight.w300), TextAlign.left);
  }

  List<Widget> createScheduleSlotPrimInfo(context) {
    var subjectTextField = createTextField(this.subject, Theme.of(context).textTheme.display2, TextAlign.left);
    var typeClassTextField = createTextField('(' + this.typeClass + ')', TextStyle(fontSize: 13.0,  color: Colors.black, fontWeight: FontWeight.w300), TextAlign.center);
    var roomTextField = createTextField(this.rooms,  Theme.of(context).textTheme.body1, TextAlign.right);

    return [
      createScheduleSlotPrimInfoColumn(subjectTextField),
      createScheduleSlotPrimInfoColumn(typeClassTextField),
      createScheduleSlotPrimInfoColumn(roomTextField)
    ];
  }

  Widget createScheduleSlotTeacherInfo(context) {
    return createTextField(this.teacher, TextStyle(fontSize: 13.0,  color: Colors.black, fontWeight: FontWeight.w300), TextAlign.left);
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      textAlign: alignment,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget createScheduleSlotPrimInfoColumn(elements) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          elements,
        ],
      ),
    );
  }
}