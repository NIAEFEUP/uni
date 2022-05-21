import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/row_container.dart';

class ScheduleSlot extends StatelessWidget {
  final String subject;
  final String rooms;
  final String begin;
  final String end;
  final String teacher;
  final String typeClass;
  final String classNumber;

  ScheduleSlot({
    Key key,
    @required this.subject,
    @required this.typeClass,
    @required this.rooms,
    @required this.begin,
    @required this.end,
    this.teacher,
    this.classNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowContainer(
        child: Container(
      padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
      child: createScheduleSlotRow(context),
    ));
  }

  Widget createScheduleSlotRow(context) {
    return Container(
        key: Key('schedule-slot-time-${this.begin}-${this.end}'),
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createScheduleSlotPrimInfo(context),
        ));
  }

  Widget createScheduleSlotTime(context) {
    return Column(
      key: Key('schedule-slot-time-${this.begin}-${this.end}'),
      children: <Widget>[
        createScheduleTime(this.begin, context),
        createScheduleTime(this.end, context)
      ],
    );
  }

  Widget createScheduleTime(String time, context) => createTextField(
      time,
      Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
      TextAlign.center);

  List<Widget> createScheduleSlotPrimInfo(context) {
    final subjectTextField = createTextField(
        this.subject,
        Theme.of(context).textTheme.headline3.apply(fontSizeDelta: 5),
        TextAlign.center);
    final typeClassTextField = createTextField(
        ' (' + this.typeClass + ')',
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center);
    final roomTextField = createTextField(
        this.rooms,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.right);
    return [
      createScheduleSlotTime(context),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              subjectTextField,
              typeClassTextField,
            ],
          ),
          Row(
            children: [
              createScheduleSlotTeacherInfo(context),
              createScheduleSlotClass(context)
            ],
          )
        ],
      ),
      createScheduleSlotPrimInfoColumn(roomTextField)
    ];
  }

  Widget createScheduleSlotTeacherInfo(context) {
    return createTextField(
        this.teacher,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center);
  }

  Widget createScheduleSlotClass(context) {
    final classText =
        this.classNumber != null ? (' | ' + this.classNumber) : '';
    return createTextField(
        classText,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center);
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget createScheduleSlotPrimInfoColumn(elements) {
    return Container(child: elements);
  }
}
