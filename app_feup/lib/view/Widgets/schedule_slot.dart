import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleSlot extends StatelessWidget {
  final int occurrId;
  final String subject;
  final String rooms;
  final String begin;
  final String end;
  final String teacher;
  final String typeClass;
  final String classNumber;

  ScheduleSlot({
    Key key,
    @required this.occurrId,
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
      time, Theme.of(context).textTheme.bodyText2, TextAlign.center);

  String toUcLink(int occurrId) {
    final String faculty = 'feup'; //should not be hardcoded
    return '${NetworkRouter.getBaseUrl(faculty)}UCURR_GERAL.FICHA_UC_VIEW?pv_ocorrencia_id=$occurrId';
  }

  _launchURL() async {
    final String url = toUcLink(occurrId);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget createSubjectButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.open_in_browser),
          iconSize: 18,
          color: Colors.grey,
          alignment: Alignment.centerRight,
          tooltip: 'Abrir página da UC no browser',
          onPressed: _launchURL,
        ),
      ],
    );
  }

  List<Widget> createScheduleSlotPrimInfo(context) {
    final subjectTextField = createTextField(
        this.subject,
        Theme.of(context)
            .textTheme
            .headline5
            .apply(color: Theme.of(context).accentColor),
        TextAlign.center);
    final typeClassTextField = createTextField(' (' + this.typeClass + ')',
        Theme.of(context).textTheme.bodyText2, TextAlign.center);
    final roomTextField = createTextField(
        this.rooms, Theme.of(context).textTheme.bodyText2, TextAlign.right);
    return [
      createScheduleSlotTime(context),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              createSubjectButton(context),
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
        this.teacher, Theme.of(context).textTheme.bodyText2, TextAlign.center);
  }

  Widget createScheduleSlotClass(context) {
    final classText =
        this.classNumber != null ? (' | ' + this.classNumber) : '';
    return createTextField(
        classText, Theme.of(context).textTheme.bodyText2, TextAlign.center);
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
