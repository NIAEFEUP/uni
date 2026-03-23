import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/academic_path/widgets/schedule_day_timeline.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class CourseUnitLecturesView extends ConsumerWidget {
  const CourseUnitLecturesView(this.lectures, this.courseUnit, {super.key});

  final List<Lecture> lectures;
  final CourseUnit courseUnit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    final firstDate = lectures.first.startTime;
    final lastDate = lectures.last.startTime;
    final start = DateTime(firstDate.year, firstDate.month, firstDate.day);
    final end = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final dayCount = end.difference(start).inDays + 1;

    final days = List.generate(
      dayCount,
      (index) => start.add(Duration(days: index)),
    );

    final daysOfTheWeek = ref
        .read(localeProvider.notifier)
        .getWeekdaysWithLocale();

    final reorderedDaysOfTheWeek = [
      daysOfTheWeek[6],
      ...daysOfTheWeek.sublist(0, 6),
    ];

    final todayIndex = days.indexWhere(
      (date) =>
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day,
    );

    final firstFutureWithLectures = days.indexWhere(
      (date) => date.isAfter(now) && _lecturesOfDay(date).isNotEmpty,
    );

    final initialTab =
        (todayIndex != -1 && _lecturesOfDay(days[todayIndex]).isNotEmpty)
        ? todayIndex
        : firstFutureWithLectures != -1
        ? firstFutureWithLectures
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Timeline(
        tabs: days
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
        content: days
            .map(
              (date) => ScheduleDayTimeline(
                key: Key('course-unit-day-view-${date.toIso8601String()}'),
                now: now,
                day: date,
                lectures: _lecturesOfDay(date),
                showClassNumber: true,
              ),
            )
            .toList(),
        initialTab: initialTab,
        tabEnabled: days
            .map((date) => _lecturesOfDay(date).isNotEmpty)
            .toList(),
      ),
    );
  }

  List<Lecture> _lecturesOfDay(DateTime date) {
    return lectures.where((lecture) {
      final startTime = lecture.startTime;
      return startTime.year == date.year &&
          startTime.month == date.month &&
          startTime.day == date.day;
    }).toList();
  }
}
