import 'package:calendar_view/calendar_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni_ui/cards/schedule_calendar_tile.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/header_info.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
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
    final controller = _createEventController();
    final weekDays = _getVisibleWeekDays();
    final earliestClass = _getEarliestClassTime();
    final latestClass = _getLatestClassTime();

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 120),
      child: Theme(
        data: Theme.of(context).copyWith(
          extensions: [
            if (Theme.of(context).brightness == Brightness.light)
              WeekViewThemeData.light().copyWith(
                borderColor: Colors.transparent,
                weekDayTextColor: Theme.of(context).colorScheme.onSecondary,
              )
            else
              WeekViewThemeData.dark().copyWith(
                borderColor: Colors.transparent,
              ),
          ],
        ),
        child: CalendarControllerProvider(
          controller: controller,
          child: WeekView(
            backgroundColor: Theme.of(context).colorScheme.surface,
            showVerticalLines: false,
            controller: controller,
            initialDay: earliestClass,
            weekDays: weekDays,
            showLiveTimeLineInAllDays: true,
            weekNumberBuilder: (weekNum) => const SizedBox.shrink(),
            onEventTap: (events, date) => _handleEventTap(context, ref, events),
            weekPageHeaderBuilder: WeekHeader.hidden,
            minDay: earliestClass,
            maxDay: latestClass,
            startHour: 7,
            hourIndicatorSettings: HourIndicatorSettings(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(0x10),
            ),
            timeLineBuilder: (date) => _buildTimeLineMark(context, date),
            eventTileBuilder: (date, events, boundary, start, end) =>
                _buildEventTile(context, events),
            weekTitleBackgroundColor: Theme.of(context).colorScheme.surface,
            weekDayStringBuilder: (day) => _formatWeekday(context, day),
            liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // --- logic ---

  EventController<Lecture> _createEventController() {
    final controller = EventController<Lecture>();
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
    return controller;
  }

  List<WeekDays> _getVisibleWeekDays() {
    final days = [
      WeekDays.monday,
      WeekDays.tuesday,
      WeekDays.wednesday,
      WeekDays.thursday,
      WeekDays.friday,
    ];

    final hasSaturdayLectures = lectures.any(
      (l) => l.startTime.weekday == DateTime.saturday,
    );

    if (hasSaturdayLectures) {
      days.add(WeekDays.saturday);
    }

    return days;
  }

  DateTime _getEarliestClassTime() {
    return lectures
        .sorted((a, b) => a.startTime.compareTo(b.startTime))
        .first
        .startTime;
  }

  DateTime _getLatestClassTime() {
    return lectures
        .sorted((a, b) => a.startTime.compareTo(b.startTime))
        .last
        .endTime;
  }

  // --- builders ---

  void _handleEventTap(
    BuildContext context,
    WidgetRef ref,
    List<CalendarEventData<Lecture>> events,
  ) {
    if (events.isEmpty) {
      return;
    }
    final lecture = events.first.event;
    if (lecture == null) {
      return;
    }

    final profile = ref.read(profileProvider).value;
    final courseUnit = profile?.courseUnits.firstWhereOrNull(
      (unit) => unit.occurrId == lecture.occurrId,
    );

    showDialog(
      context: context,
      builder: (context) {
        return ModalDialog(
          children: [
            ModalHeader(
              name: lecture.subject,
              durations: [
                '${_formatTime(lecture.startTime)} - ${_formatTime(lecture.endTime)}',
              ],
            ),
            ModalInfoRow(
              title: S.of(context).location,
              description: lecture.room,
              icon: UniIcons.mapPin,
            ),
            ModalInfoRow(
              title: S.of(context).instructor,
              description: lecture.teacherName,
              icon: UniIcons.userIcon,
            ),
            ModalInfoRow(
              title: S.of(context).course_class,
              description: lecture.classNumber,
              icon: UniIcons.classes,
            ),
            ModalInfoRow(
              title: S.of(context).type,
              description: lecture.typeClass,
              icon: UniIcons.lecture,
            ),
            if (courseUnit != null && courseUnit.occurrId != null)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute<CourseUnitDetailPageView>(
                      builder: (context) =>
                          CourseUnitDetailPageView(courseUnit),
                    ),
                  );
                },
                child: ModalInfoRow(
                  title: S.of(context).course_info,
                  description: lecture.subject,
                  icon: UniIcons.courseUnit,
                  trailing: UniIcon(
                    UniIcons.caretRight,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTimeLineMark(BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: DefaultTimeLineMark(
        date: date,
        markingStyle: Theme.of(context).textTheme.labelLarge,
        timeStringBuilder: (date, {secondaryDate}) =>
            DateFormat.Hm().format(date),
      ),
    );
  }

  Widget _buildEventTile(
    BuildContext context,
    List<CalendarEventData<Lecture>> events,
  ) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }
    final lecture = events.first.event;
    if (lecture == null) {
      return const SizedBox.shrink();
    }

    final isCurrent =
        now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);

    return ScheduleCalendarTile(
      acronym: lecture.acronym,
      typeClass: lecture.typeClass,
      room: lecture.room,
      timeRange:
          '${_formatTime(lecture.startTime)} - ${_formatTime(lecture.endTime)}',
      teacherName: lecture.teacherName,
      isCurrent: isCurrent,
    );
  }

  String _formatWeekday(BuildContext context, int day) {
    final locale = Localizations.localeOf(context).toString();
    final symbols = DateFormat.EEEE(locale).dateSymbols;
    return symbols.SHORTWEEKDAYS[day + 1].capitalize().substring(0, 3);
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
  }
}
