import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/locale_notifier.dart';
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
          color: _getColorForSubject(lecture.subject),
          event: lecture,
        ),
      );
    }

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
    final hasFridayLectures = hasLecturesOnWeekday[DateTime.friday] ?? false;

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

    // Determine the week to display
    // The parent SchedulePage already handles determining which week to show
    // (current week or next week if it's the weekend with no remaining classes)
    // So we just show the week that was passed to us
    final weekToShow = currentWeek.start;

    // End date is always Friday unless there are Saturday classes
    final weekEndDate =
        hasSaturdayLectures
            ? weekToShow.add(const Duration(days: 5)) // Saturday
            : weekToShow.add(const Duration(days: 4)); // Friday

    return CalendarControllerProvider(
      controller: controller,
      child: WeekView(
        controller: controller,
        initialDay: now,
        heightPerMinute: 1.2,
        weekDays: weekDaysList,
        showLiveTimeLineInAllDays: true,
        timeLineBuilder: (date) {
          final hour = date.hour;
          return Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
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

          final tileColor =
              isCurrentClass
                  ? primaryVibrant // Uni red for current class
                  : Theme.of(
                    context,
                  ).colorScheme.surfaceContainer; // Uni white for other classes

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(4),
              border:
                  isCurrentClass
                      ? Border.all(color: primaryVibrant, width: 2)
                      : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section: acronym and type badge
                  Column(
                    children: [
                      Text(
                        lecture.acronym,
                        style: TextStyle(
                          color: isCurrentClass ? secondary : primaryVibrant,
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
                        textColor: Colors.white,
                      ),
                    ],
                  ),

                  // Bottom section: divider and location
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color:
                            isCurrentClass
                                ? secondary
                                : primaryVibrant.withOpacity(0.72),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UniIcon(
                            UniIcons.mapPin,
                            color:
                                isCurrentClass
                                    ? secondary.withOpacity(0.2)
                                    : primaryVibrant.withOpacity(0.2),
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              lecture.room,
                              style: TextStyle(
                                color:
                                    isCurrentClass ? secondary : primaryVibrant,
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
                ],
              ),
            ),
          );
        },
        headerStyle: HeaderStyle(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          headerTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // weekDayStringBuilder: (weekDay) {
        //   // Get weekday abbreviations from locale using SHORTWEEKDAYS
        //   final locale = Localizations.localeOf(context);
        //   final dateSymbols = DateFormat.EEEE(locale.toString()).dateSymbols;
        //   final shortWeekdays = dateSymbols.SHORTWEEKDAYS;

        //   // Map WeekDays enum to SHORTWEEKDAYS array indices
        //   // SHORTWEEKDAYS array: [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
        //   final weekdayMap = {
        //     WeekDays.sunday: 0,
        //     WeekDays.monday: 1,
        //     WeekDays.tuesday: 2,
        //     WeekDays.wednesday: 3,
        //     WeekDays.thursday: 4,
        //     WeekDays.friday: 5,
        //     WeekDays.saturday: 6,
        //   };

        //   final index = weekdayMap[weekDay] ?? 1;
        //   return shortWeekdays[index];
        // },
        hourIndicatorSettings: const HourIndicatorSettings(color: Colors.black),
        weekPageHeaderBuilder: WeekHeader.hidden,
        minDay: weekToShow,
        maxDay: weekEndDate,
        startHour: 8,
        endHour: 20,
        liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
          color: primaryVibrant,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Color _getColorForSubject(String subject) {
    // Generate a consistent color based on subject name
    final hash = subject.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1, hue, 0.6, 0.5).toColor();
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
