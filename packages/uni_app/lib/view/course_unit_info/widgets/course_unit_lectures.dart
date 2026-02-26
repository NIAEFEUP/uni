import 'package:collection/collection.dart';
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

    final groupedByDay = groupBy<Lecture, DateTime>(
      lectures,
      (lecture) => DateTime(
        lecture.startTime.year,
        lecture.startTime.month,
        lecture.startTime.day,
      ),
    );

    final days = groupedByDay.keys.toList();

    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

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

    final firstFutureIndex = days.indexWhere((date) => date.isAfter(now));

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
                lectures: groupedByDay[date]!,
              ),
            )
            .toList(),
        initialTab: todayIndex != -1
            ? todayIndex
            : firstFutureIndex != -1
            ? firstFutureIndex
            : 0,
        tabEnabled: days.map((_) => true).toList(),
      ),
    );
  }
}
