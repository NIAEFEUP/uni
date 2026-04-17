import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/schedule_calendar_view.dart';
import 'package:uni/view/academic_path/widgets/schedule_day_timeline.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/common_widgets/view_toggle_button.dart';
import 'package:uni_ui/timeline/timeline.dart';

class SchedulePageView extends ConsumerStatefulWidget {
  SchedulePageView(
    this.lectures, {
    required this.now,
    required DateTime startOfWeek,
    super.key,
  }) : currentWeek = Week(start: startOfWeek);

  final DateTime now;
  final List<Lecture> lectures;
  final Week currentWeek;

  @override
  ConsumerState<SchedulePageView> createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends ConsumerState<SchedulePageView> {
  int _selectedView = 0; // 0 = List view, 1 = Calendar view

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ViewToggleButton(
            options: [locale.list_view, locale.calendar_view],
            selected: _selectedView,
            onSelectionChanged: (index) {
              setState(() {
                _selectedView = index;
              });
            },
          ),
        ),
        Expanded(
          child: _selectedView == 0
              ? _buildListView(context)
              : _buildCalendarView(),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    final allDates = List.generate(
      14,
      (index) => widget.currentWeek.start.add(Duration(days: index)),
    );

    // Filter out Saturday (6) and Sunday (0/7) unless there are lectures
    final reorderedDates = allDates.where((date) {
      final weekday = date.weekday;
      final isSaturday = weekday == DateTime.saturday;
      final isSunday = weekday == DateTime.sunday;

      if (isSaturday || isSunday) {
        return _lecturesOfDay(widget.lectures, date).isNotEmpty;
      }
      return true;
    }).toList();

    final daysOfTheWeek = ref
        .read(localeProvider.notifier)
        .getWeekdaysWithLocale();

    final reorderedDaysOfTheWeek = [
      daysOfTheWeek[6],
      ...daysOfTheWeek.sublist(0, 6),
    ];

    final todayIndex = reorderedDates.indexWhere(
      (date) =>
          date.year == widget.now.year &&
          date.month == widget.now.month &&
          date.day == widget.now.day,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Timeline(
        tabs: reorderedDates
            .map(
              (date) => SizedBox(
                width: 30,
                height: 34,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        reorderedDaysOfTheWeek[(date.weekday) % 7].substring(
                          0,
                          3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${date.day}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        content: reorderedDates
            .map(
              (date) => ScheduleDayTimeline(
                key: Key('schedule-page-day-view-${date.weekday}'),
                now: widget.now,
                day: date,
                lectures: _lecturesOfDay(widget.lectures, date),
                onLectureTap: (lecture) {
                  final profile = ref.watch(
                    profileProvider.select((value) => value.value),
                  );

                  if (profile != null) {
                    final ocorrenciasUnits = profile.courseUnits
                        .where(
                          (unit) =>
                              unit.occurrId != null &&
                              unit.occurrId == lecture.occurrId,
                        )
                        .toList();
                    if (ocorrenciasUnits.isNotEmpty) {
                      final correctUnit = ocorrenciasUnits.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute<CourseUnitDetailPageView>(
                          builder: (context) =>
                              CourseUnitDetailPageView(correctUnit),
                        ),
                      );
                    }
                  }
                },
              ),
            )
            .toList(),
        initialTab:
            (todayIndex != -1 &&
                _lecturesOfDay(
                  widget.lectures,
                  reorderedDates[todayIndex],
                ).isNotEmpty)
            ? todayIndex
            : reorderedDates.indexWhere(
                (date) =>
                    date.isAfter(widget.now) &&
                    _lecturesOfDay(widget.lectures, date).isNotEmpty,
              ),
        tabEnabled: reorderedDates
            .map((date) => _lecturesOfDay(widget.lectures, date).isNotEmpty)
            .toList(),
      ),
    );
  }

  Widget _buildCalendarView() {
    return ScheduleCalendarView(
      widget.lectures,
      startOfWeek: widget.currentWeek.start,
      now: widget.now,
    );
  }

  List<Lecture> _lecturesOfDay(List<Lecture> lectures, DateTime date) {
    return lectures.where((lecture) {
      final startTime = lecture.startTime;
      return startTime.year == date.year &&
          startTime.month == date.month &&
          startTime.day == date.day;
    }).toList();
  }
}
