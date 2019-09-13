import 'package:app_feup/view/Widgets/RowContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return new RowContainer(
          child: new Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
            child: createScheduleSlotRow(context),
          )
        );
  }


  Widget createScheduleSlotRow(context) {
    return new Container (
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createScheduleSlotPrimInfo(context),
        )
    );
  }

  Widget createScheduleSlotTime(context) {
    return new Column(
      children: <Widget>[
        createScheduleTime(this.begin, context),
        createScheduleTime(this.end, context)
      ],
    );
  }

  Widget createScheduleTime(String time, context) =>
      createTextField(time, Theme.of(context).textTheme.display1.apply(fontSizeDelta: -3), TextAlign.center);

  List<Widget> createScheduleSlotPrimInfo(context) {
    var subjectTextField = createTextField(
        this.subject,
        Theme.of(context).textTheme.display2.apply(fontSizeDelta: 5),
        TextAlign.center);
    var typeClassTextField = createTextField(
        ' (' + this.typeClass + ')',
        Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4),
        TextAlign.center);
    var roomTextField = createTextField(
        this.rooms,
        Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4),
        TextAlign.right);
    return [
      createScheduleSlotTime(context),
      new Column(
        children: <Widget>[
            new Row(
              children: <Widget>[
              subjectTextField,
              typeClassTextField,
              ],
            ),
            createScheduleSlotTeacherInfo(context)
        ],
      ),
      createScheduleSlotPrimInfoColumn(roomTextField)
    ];
  }

  Widget createScheduleSlotTeacherInfo(context) {
    return createTextField(this.teacher, Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4), TextAlign.center);
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget createScheduleSlotPrimInfoColumn(elements) {
    return Container(
      child: elements
    );
  }
}