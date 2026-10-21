import 'package:collection/collection.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';

class ExamModal extends ConsumerWidget {
  const ExamModal({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final calendar = DeviceCalendar.instance;

    return ModalDialog(
      children: [
        Text(exam.subject, style: Theme.of(context).textTheme.headlineMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UniIcon(
                UniIcons.clock,
                size: 20,
                color: Theme.of(context).colorScheme.onSecondary,
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
                color: Theme.of(context).colorScheme.onSecondary,
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
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          onPressed: () async {
            final status = await calendar.hasPermissions();
            if (status != CalendarPermissionStatus.granted) {
              final newStatus = await calendar.requestPermissions();
              if (newStatus != CalendarPermissionStatus.granted) {
                return;
              }
            }

            await calendar.showCreateEventModal(
              title: exam.subject,
              description: exam.examType,
              location: exam.rooms.join(', '),
              startDate: exam.start,
              endDate: exam.finish,
            );
          },
        ),
        ModalInfoRow(
  title: S.of(context).room,
  icon: UniIcons.mapPin,
  descriptionWidget: Wrap(
    spacing: 6,
    children: [
      for (final (index, room) in exam.rooms.indexed)
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              '/${NavigationItem.navMap.route}',
              arguments: room,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              index < exam.rooms.length - 1 ? '$room,' : room,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
    ],
  ),
),
      ],
    );
  }
}