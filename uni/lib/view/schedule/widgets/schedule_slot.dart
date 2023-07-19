import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleSlot extends StatelessWidget {
  final String subject;
  final String rooms;
  final DateTime begin;
  final DateTime end;
  final String teacher;
  final String typeClass;
  final String? classNumber;
  final int occurrId;

  const ScheduleSlot({
    Key? key,
    required this.subject,
    required this.typeClass,
    required this.rooms,
    required this.begin,
    required this.end,
    required this.occurrId,
    required this.teacher,
    this.classNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowContainer(
        child: Container(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
      child: createScheduleSlotRow(context),
    ));
  }

  Widget createScheduleSlotRow(context) {
    return Container(
        key: Key(
            'schedule-slot-time-${DateFormat("HH:mm").format(begin)}-${DateFormat("HH:mm").format(end)}'),
        margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createScheduleSlotPrimInfo(context),
        ));
  }

  Widget createScheduleSlotTime(context) {
    return Column(
      key: Key(
          'schedule-slot-time-${DateFormat("HH:mm").format(begin)}-${DateFormat("HH:mm").format(end)}'),
      children: <Widget>[
        createScheduleTime(DateFormat("HH:mm").format(begin), context),
        createScheduleTime(DateFormat("HH:mm").format(end), context)
      ],
    );
  }

  Widget createScheduleTime(String time, context) => createTextField(
      time, Theme.of(context).textTheme.bodyMedium, TextAlign.center);

  String toUcLink(int occurrId) {
    const String faculty = 'feup'; //should not be hardcoded
    return '${NetworkRouter.getBaseUrl(faculty)}'
        'UCURR_GERAL.FICHA_UC_VIEW?pv_ocorrencia_id=$occurrId';
  }

  _launchURL() async {
    final String url = toUcLink(occurrId);
    await launchUrl(Uri.parse(url));
  }

  Widget createSubjectButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension / 3,
              minWidth: kMinInteractiveDimension / 3),
          icon: const Icon(Icons.open_in_browser),
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
        subject,
        Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: Theme.of(context).colorScheme.tertiary),
        TextAlign.center);
    final typeClassTextField = createTextField(' ($typeClass)',
        Theme.of(context).textTheme.bodyMedium, TextAlign.center);
    final roomTextField = createTextField(
        rooms, Theme.of(context).textTheme.bodyMedium, TextAlign.right);
    return [
      createScheduleSlotTime(context),
      Expanded(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createSubjectButton(context),
              subjectTextField,
              typeClassTextField,
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: createScheduleSlotTeacherClassInfo(context)),
        ],
      )),
      roomTextField
    ];
  }

  Widget createScheduleSlotTeacherClassInfo(context) {
    return createTextField(
        classNumber != null ? '$classNumber | $teacher' : teacher,
        Theme.of(context).textTheme.bodyMedium,
        TextAlign.center);
  }

  Widget createTextField(text, style, alignment) {
    return Text(text,
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
        style: style,
        textAlign: alignment);
  }
}
