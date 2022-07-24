import 'package:flutter/material.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleSlot extends StatelessWidget {
  final String subject;
  final String rooms;
  final String begin;
  final String end;
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
        key: Key('schedule-slot-time-$begin-$end'),
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
      key: Key('schedule-slot-time-$begin-$end'),
      children: <Widget>[
        createScheduleTime(begin, context),
        createScheduleTime(end, context)
      ],
    );
  }

  Widget createScheduleTime(String time, context) => createTextField(
      time, Theme.of(context).textTheme.bodyText2, TextAlign.center);

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
            .headline5!
            .apply(color: Theme.of(context).colorScheme.secondary),
        TextAlign.center);
    final typeClassTextField = createTextField(' ($typeClass)',
        Theme.of(context).textTheme.bodyText2, TextAlign.center);
    final roomTextField = createTextField(
        rooms, Theme.of(context).textTheme.bodyText2, TextAlign.right);
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
        teacher, Theme.of(context).textTheme.bodyText2, TextAlign.center);
  }

  Widget createScheduleSlotClass(context) {
    final classText = classNumber != null ? (' | $classNumber') : '';
    return createTextField(
        classText, Theme.of(context).textTheme.bodyText2, TextAlign.center);
  }

  Widget createTextField(text, style, alignment) {
    return Text(text,
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
        style: style,
        textAlign: alignment);
  }

  Widget createScheduleSlotPrimInfoColumn(elements) {
    return Container(child: elements);
  }
}
