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
      child: Container(
          key: Key(
              'schedule-slot-time-${DateFormat("HH:mm").format(begin)}-${DateFormat("HH:mm").format(end)}'),
          margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: createScheduleSlotPrimInfo(context),
          )),
    ));
  }

  List<Widget> createScheduleSlotPrimInfo(context) {
    final subjectTextField = TextFieldWidget(
        text: subject,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: Theme.of(context).colorScheme.tertiary),
        alignment: TextAlign.center);
    final typeClassTextField = TextFieldWidget(
        text: ' ($typeClass)',
        style: Theme.of(context).textTheme.bodyMedium,
        alignment: TextAlign.center);
    final roomTextField = TextFieldWidget(
        text: rooms,
        style: Theme.of(context).textTheme.bodyMedium,
        alignment: TextAlign.right);
    return [
      ScheduleTimeWidget(
          begin: DateFormat("HH:mm").format(begin),
          end: DateFormat("HH:mm").format(end)),
      Expanded(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SubjectButtonWidget(
                occurrId: occurrId,
              ),
              subjectTextField,
              typeClassTextField,
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScheduleTeacherClassInfoWidget(
                  classNumber: classNumber, teacher: teacher)),
        ],
      )),
      roomTextField
    ];
  }
}

class SubjectButtonWidget extends StatelessWidget {
  final int occurrId;

  const SubjectButtonWidget({super.key, required this.occurrId});

  String toUcLink(int occurrId) {
    const String faculty = 'feup'; // should not be hardcoded
    return '${NetworkRouter.getBaseUrl(faculty)}'
        'UCURR_GERAL.FICHA_UC_VIEW?pv_ocorrencia_id=$occurrId';
  }

  Future<void> _launchURL() async {
    final String url = toUcLink(occurrId);
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
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
}

class ScheduleTeacherClassInfoWidget extends StatelessWidget {
  final String? classNumber;
  final String teacher;

  const ScheduleTeacherClassInfoWidget(
      {super.key, required this.teacher, this.classNumber});

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      text: classNumber != null ? '$classNumber | $teacher' : teacher,
      style: Theme.of(context).textTheme.bodyMedium,
      alignment: TextAlign.center,
    );
  }
}

class ScheduleTimeWidget extends StatelessWidget {
  final String begin;
  final String end;

  const ScheduleTimeWidget({super.key, required this.begin, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key('schedule-slot-time-$begin-$end'),
      children: <Widget>[
        ScheduleTimeTextField(time: begin, context: context),
        ScheduleTimeTextField(time: end, context: context),
      ],
    );
  }
}

class ScheduleTimeTextField extends StatelessWidget {
  final String time;
  final BuildContext context;

  const ScheduleTimeTextField(
      {super.key, required this.time, required this.context});

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      text: time,
      style: Theme.of(context).textTheme.bodyMedium,
      alignment: TextAlign.center,
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign alignment;

  const TextFieldWidget({
    super.key,
    required this.text,
    required this.style,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      softWrap: false,
      maxLines: 1,
      style: style,
      textAlign: alignment,
    );
  }
}
