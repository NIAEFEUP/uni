import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/schedule_day_timeline.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class ScheduleListView extends ConsumerWidget {
  const ScheduleListView({
    required this.lectures,
    required this.now,
    required this.currentWeek,
    this.showClassNumber = false,
    super.key,
  });

  final DateTime now;
  final List<Lecture> lectures;
  final Week currentWeek;
  final bool showClassNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDates = List.generate(
      14,
      (index) => currentWeek.start.add(Duration(days: index)),
    );

    // Filter out Saturday (6) and Sunday (0/7) unless there are lectures
    final reorderedDates = allDates.where((date) {
      final weekday = date.weekday;
      final isSaturday = weekday == DateTime.saturday;
      final isSunday = weekday == DateTime.sunday;

      if (isSaturday || isSunday) {
        return _lecturesOfDay(lectures, date).isNotEmpty;
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
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day,
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
                now: now,
                day: date,
                lectures: _lecturesOfDay(lectures, date),
                showClassNumber: showClassNumber,
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
                  lectures,
                  reorderedDates[todayIndex],
                ).isNotEmpty)
            ? todayIndex
            : reorderedDates.indexWhere(
                (date) =>
                    date.isAfter(now) &&
                    _lecturesOfDay(lectures, date).isNotEmpty,
              ),
        tabEnabled: reorderedDates
            .map((date) => _lecturesOfDay(lectures, date).isNotEmpty)
            .toList(),
      ),
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
