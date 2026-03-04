import 'package:calendar_view/calendar_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/utils/time/week.dart';
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
          color: _getColorForSubject(lecture.subject),
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
    final weekEndDate = hasSaturdayLectures
        ? weekToShow.add(const Duration(days: 5)) // Saturday
        : weekToShow.add(const Duration(days: 4)); // Friday

    return CalendarControllerProvider(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 150),
        child: WeekView(
          controller: controller,
          initialDay: earliestClass,
          weekDays: weekDaysList,
          showLiveTimeLineInAllDays: true,
          weekNumberBuilder: (weekNum) {
            return Container();
          },
          weekPageHeaderBuilder: WeekHeader.hidden,
          minDay: earliestClass,
          maxDay: latestClass,
          startHour: 8,
          endHour: 20,
          timeLineBuilder: (date) {
            final hour = date.hour;
            return Container(
              alignment: Alignment.topCenter,
              // padding: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                // strutStyle: const StrutStyle(leading: 0, forceStrutHeight: true, height: 0.6),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
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

            // Color is chosen basen on if a student has a class at the moment
            final tileColor = isCurrentClass
                ? primaryVibrant
                : Theme.of(context).colorScheme.primaryContainer;

            return GestureDetector(
              onTap: () {
                final profile = ref.watch(
                  profileProvider.select((value) => value.value),
                );

                if (profile != null) {
                  final courseUnit = profile.courseUnits.firstWhereOrNull(
                    (unit) => unit.abbreviation == lecture.acronym,
                  );
                  if (courseUnit != null && courseUnit.occurrId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<CourseUnitDetailPageView>(
                        builder: (context) =>
                            CourseUnitDetailPageView(courseUnit),
                      ),
                    );
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(4),
                  border: isCurrentClass
                      ? Border.all(color: primaryVibrant, width: 2)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
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
                                  ? secondary
                                  : primaryVibrant,
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
                            backgroundColor: _getTypeClassColor(
                              lecture.typeClass,
                            ),
                            textColor: Colors.white,
                          ),
                          Text(
                            '${_formatTime(lecture.startTime)} - ${_formatTime(lecture.endTime)}',
                            style: TextStyle(
                              color: isCurrentClass
                                  ? secondary
                                  : primaryVibrant,
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
                                  ? secondary
                                  : primaryVibrant,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: isCurrentClass
                                ? secondary
                                : primaryVibrant.withOpacity(0.72),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UniIcon(
                                UniIcons.mapPin,
                                color: isCurrentClass
                                    ? secondary.withOpacity(0.8)
                                    : primaryVibrant.withOpacity(0.8),
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  lecture.room,
                                  style: TextStyle(
                                    color: isCurrentClass
                                        ? secondary
                                        : primaryVibrant,
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
          weekDayStringBuilder: (weekDay) {
            final locale = Localizations.localeOf(context);
            final dateSymbols = DateFormat.EEEE(locale.toString()).dateSymbols;
            final shortWeekdays = dateSymbols.NARROWWEEKDAYS;

            return shortWeekdays[weekDay + 1];
          },
          // hourIndicatorSettings: const HourIndicatorSettings(),
          liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
            color: primaryVibrant,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
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
