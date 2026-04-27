import 'package:calendar_view/calendar_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCalendarView extends ConsumerWidget {
  ScheduleCalendarView(
    this.lectures, {
    required this.now,
    required DateTime startOfWeek,
    super.key,
  }) : currentWeek = Week(start: startOfWeek);

  final DateTime now;
  final List<Lecture> lectures;
  final Week currentWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = EventController<Lecture>();

    // Add lectures as calendar events
    for (final lecture in lectures) {
      controller.add(
        CalendarEventData(
          title: lecture.subject,
          date: lecture.startTime,
          startTime: lecture.startTime,
          endTime: lecture.endTime,
          description: '${lecture.room}\n${lecture.typeClass}',
          event: lecture,
        ),
      );
    }

    // determine earliest class
    final earliestClass = lectures
        .sorted((a, b) => a.startTime.compareTo(b.startTime))
        .first
        .startTime;
    final latestClass = lectures
        .sorted((a, b) => a.startTime.compareTo(b.startTime))
        .last
        .endTime;

    // Determine which days to show (exclude Saturday and Sunday without lectures)
    final hasLecturesOnWeekday = <int, bool>{};
    for (var i = DateTime.monday; i <= DateTime.sunday; i++) {
      hasLecturesOnWeekday[i] = lectures.any(
        (lecture) => lecture.startTime.weekday == i,
      );
    }

    // Determine which days to display
    final hasSaturdayLectures =
        hasLecturesOnWeekday[DateTime.saturday] ?? false;

    final weekDaysList = <WeekDays>[
      WeekDays.monday,
      WeekDays.tuesday,
      WeekDays.wednesday,
      WeekDays.thursday,
      WeekDays.friday,
    ];

    if (hasSaturdayLectures) {
      weekDaysList.add(WeekDays.saturday);
    }

    return CalendarControllerProvider(
      controller: controller,
      child: WeekView(
        backgroundColor: Theme.of(context).colorScheme.surface,
        showVerticalLines: false,
        controller: controller,
        initialDay: earliestClass,
        weekDays: weekDaysList,
        showLiveTimeLineInAllDays: true,
        weekNumberBuilder: (weekNum) {
          return Container();
        },
        onEventTap: (events, date) {
          if (events.isEmpty) {
            return;
          }
          final lecture = events.first.event;
          if (lecture == null) {
            return;
          }

          final profile = ref.read(profileProvider).value;

          if (profile != null) {
            final courseUnit = profile.courseUnits.firstWhereOrNull(
              (unit) => unit.occurrId == lecture.occurrId,
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
        weekPageHeaderBuilder: WeekHeader.hidden,
        minDay: earliestClass,
        maxDay: latestClass,
        startHour: 7,
        hourIndicatorSettings: HourIndicatorSettings(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(0x10),
        ),
        // small hour indicator on the left of the line that separates hours
        timeLineBuilder: (date) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: DefaultTimeLineMark(
              date: date,
              markingStyle: Theme.of(context).textTheme.labelLarge,
              timeStringBuilder: (date, {secondaryDate}) {
                return DateFormat.Hm().format(date);
              },
            ),
          );
        },
        eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
          if (events.isEmpty) {
            return const SizedBox.shrink();
          }

          final event = events.first;
          final lecture = event.event;

          if (lecture == null) {
            return const SizedBox.shrink();
          }

          // Check if this is the current class
          final isCurrentClass =
              now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);

          // Color is chosen basen on if a student has a class at the moment
          final tileColor = isCurrentClass
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.secondary;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: tileColor,
              gradient: isCurrentClass
                  ? RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.onTertiary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                      center: Alignment.topLeft,
                      radius: 2,
                      stops: const [0, 1],
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section: acronym and type badge
                  Column(
                    children: [
                      Text(
                        lecture.acronym,
                        style: TextStyle(
                          color: isCurrentClass
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Badge(
                        label: Text(lecture.typeClass),
                        backgroundColor: _getTypeClassColor(lecture.typeClass),
                        textColor: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        '${_formatTime(lecture.startTime)} - ${_formatTime(lecture.endTime)}',
                        style: TextStyle(
                          color: isCurrentClass
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSecondary,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        lecture.teacher,
                        style: TextStyle(
                          color: isCurrentClass
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSecondary,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UniIcon(
                        UniIcons.mapPin,
                        color: isCurrentClass
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onSecondary,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          lecture.room,
                          style: TextStyle(
                            color: isCurrentClass
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.onSecondary,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        weekTitleBackgroundColor: Theme.of(context).colorScheme.surface,
        // change the weekday string (Seg, Ter, Qua, etc.)
        weekDayStringBuilder: (weekDay) {
          final locale = Localizations.localeOf(context);
          final dateSymbols = DateFormat.EEEE(locale.toString()).dateSymbols;
          final shortWeekdays = dateSymbols.SHORTWEEKDAYS;

          return shortWeekdays[weekDay + 1].capitalize().substring(0, 3);
        },
        liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
  }

  Color _getTypeClassColor(String type) {
    const scheduleTypeColors = {
      'T': BadgeColors.t,
      'TP': BadgeColors.tp,
      'P': BadgeColors.p,
      'PL': BadgeColors.pl,
      'OT': BadgeColors.ot,
      'TC': BadgeColors.tc,
    };
    return scheduleTypeColors[type] ?? BadgeColors.t;
  }
}
