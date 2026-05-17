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
    final controller = _createEventController();
    final weekDays = _getVisibleWeekDays();
    final earliestClass = _getEarliestClassTime();
    final latestClass = _getLatestClassTime();

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 120),
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
    if (profile == null) {
      return;
    }

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

    final tileColor = isCurrent
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tileColor,
        gradient: isCurrent ? _getCurrentClassGradient(context) : null,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
            blurRadius: 2,
          ),
        ],
      ),
      child: _buildEventTileContent(context, lecture, isCurrent),
    );
  }

  Gradient _getCurrentClassGradient(BuildContext context) {
    return RadialGradient(
      colors: [
        Theme.of(context).colorScheme.onTertiary,
        Theme.of(context).colorScheme.tertiary,
      ],
      center: Alignment.topLeft,
      radius: 2,
      stops: const [0, 1],
    );
  }

  Widget _buildEventTileContent(
    BuildContext context,
    Lecture lecture,
    bool isCurrent,
  ) {
    final textColor = isCurrent
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onSecondary;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                lecture.acronym,
                style: TextStyle(
                  color: textColor,
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
                style: TextStyle(color: textColor, fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                lecture.teacher,
                style: TextStyle(color: textColor, fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          _buildLocationRow(context, lecture.room, textColor),
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context, String room, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        UniIcon(UniIcons.mapPin, color: color, size: 12),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            room,
            style: TextStyle(color: color, fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
