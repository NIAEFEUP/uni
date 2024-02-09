import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/view/common_widgets/row_container.dart';

class ScheduleSlot extends StatelessWidget {
  const ScheduleSlot({
    required this.subject,
    required this.typeClass,
    required this.rooms,
    required this.begin,
    required this.end,
    required this.occurrId,
    required this.teacher,
    this.classNumber,
    super.key,
  });
  final String subject;
  final String rooms;
  final DateTime begin;
  final DateTime end;
  final String teacher;
  final String typeClass;
  final String? classNumber;
  final int occurrId;

  @override
  Widget build(BuildContext context) {
    return RowContainer(
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 22,
          right: 22,
        ),
        child: Container(
          key: Key(
            'schedule-slot-time-${DateFormat("HH:mm").format(begin)}-'
            '${DateFormat("HH:mm").format(end)}',
          ),
          margin: const EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: createScheduleSlotPrimInfo(context),
          ),
        ),
      ),
    );
  }

  List<Widget> createScheduleSlotPrimInfo(BuildContext context) {
    final subjectTextField = TextFieldWidget(
      text: subject,
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .apply(color: Theme.of(context).colorScheme.tertiary),
      alignment: TextAlign.center,
    );
    final typeClassTextField = TextFieldWidget(
      text: ' ($typeClass)',
      style: Theme.of(context).textTheme.bodyMedium,
      alignment: TextAlign.center,
    );
    final roomTextField = Text(
      rooms,
      style: Theme.of(context).textTheme.bodyMedium,
    );
    return [
      ScheduleTimeWidget(
        begin: DateFormat('HH:mm').format(begin),
        end: DateFormat('HH:mm').format(end),
      ),
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
                classNumber: classNumber,
                teacher: teacher,
              ),
            ),
          ],
        ),
      ),
      roomTextField,
    ];
  }
}

class SubjectButtonWidget extends StatelessWidget {
  const SubjectButtonWidget({required this.occurrId, super.key});
  final int occurrId;

  String toUcLink(int occurrId) {
    const faculty = 'feup'; // should not be hardcoded
    return '${NetworkRouter.getBaseUrl(faculty)}'
        'UCURR_GERAL.FICHA_UC_VIEW?pv_ocorrencia_id=$occurrId';
  }

  Future<void> _launchURL(BuildContext context) async {
    final url = toUcLink(occurrId);
    await launchUrlWithToast(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension / 3,
            minWidth: kMinInteractiveDimension / 3,
          ),
          icon: const Icon(Icons.open_in_browser),
          iconSize: 18,
          color: Colors.grey,
          alignment: Alignment.centerRight,
          tooltip: 'Abrir página da UC no browser',
          onPressed: () => _launchURL(context),
        ),
      ],
    );
  }
}

class ScheduleTeacherClassInfoWidget extends StatelessWidget {
  const ScheduleTeacherClassInfoWidget({
    required this.teacher,
    this.classNumber,
    super.key,
  });
  final String? classNumber;
  final String teacher;

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
  const ScheduleTimeWidget({required this.begin, required this.end, super.key});
  final String begin;
  final String end;

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
  const ScheduleTimeTextField({
    required this.time,
    required this.context,
    super.key,
  });
  final String time;
  final BuildContext context;

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
  const TextFieldWidget({
    required this.text,
    required this.style,
    required this.alignment,
    super.key,
  });
  final String text;
  final TextStyle? style;
  final TextAlign alignment;

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
