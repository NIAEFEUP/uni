import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';

class ExamModal extends StatelessWidget {
  const ExamModal({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();

    return ModalDialog(
      children: [
        Text(
          exam.subject,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UniIcon(
                UniIcons.clock,
                size: 20,
                color: Theme.of(context).shadowColor,
              ),
              const SizedBox(width: 8),
              Text(
                '${exam.formatTime(exam.start)} - ${exam.formatTime(exam.finish)}',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 16),
              UniIcon(
                UniIcons.calendar,
                size: 20,
                color: Theme.of(context).shadowColor,
              ),
              const SizedBox(width: 8),
              Text(
                '${exam.start.shortMonth(locale).capitalize()} ${exam.start.day}',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ModalInfoRow(
          title: S.of(context).add_to_calendar,
          icon: UniIcons.calendar,
          trailing: UniIcon(
            UniIcons.caretRight,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            final event = Event(
              title: exam.subject,
              description: exam.examType,
              location: exam.rooms.join(', '),
              startDate: exam.start,
              endDate: exam.finish,
            );
            Add2Calendar.addEvent2Cal(event);
          },
        ),
        ModalInfoRow(
          title: S.of(context).view_course_details,
          icon: UniIcons.courseUnit,
          trailing: UniIcon(
            UniIcons.caretRight,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            final profile = Provider.of<ProfileProvider>(
              context,
              listen: false,
            ).state;

            if (profile != null) {
              final courseUnit = profile.courseUnits.firstWhereOrNull(
                (unit) => unit.abbreviation == exam.subjectAcronym,
              );
              if (courseUnit != null && courseUnit.occurrId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute<CourseUnitDetailPageView>(
                    builder: (context) => CourseUnitDetailPageView(courseUnit),
                  ),
                );
              }
            }
          },
        ),
        ModalInfoRow(
          title: S.of(context).room,
          description: exam.rooms.join(', '),
          icon: UniIcons.mapPin,
        ),
      ],
    );
  }
}
