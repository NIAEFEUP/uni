import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/schedule_day_timeline.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class SchedulePageView extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final reorderedDates = List.generate(
      14,
      (index) => currentWeek.start.add(Duration(days: index)),
    );

    final daysOfTheWeek = ref
        .watch(localeProvider.notifier)
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

    final lecturesByDay = <int, List<Lecture>>{};
    for (final lecture in lectures) {
      final key = DateTime(
        lecture.startTime.year,
        lecture.startTime.month,
        lecture.startTime.day,
      ).millisecondsSinceEpoch;
      lecturesByDay.putIfAbsent(key, () => []).add(lecture);
    }

    List<Lecture> getLectures(DateTime date) {
      final key = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
      return lecturesByDay[key] ?? [];
    }

    final tabEnabled = reorderedDates
        .map((date) => getLectures(date).isNotEmpty)
        .toList();

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
        content: null,
        contentBuilder: (context, index) {
          final date = reorderedDates[index];
          return ScheduleDayTimeline(
            key: ValueKey('schedule-page-day-view-${date.millisecondsSinceEpoch}'),
            now: now,
            day: date,
            lectures: getLectures(date),
          );
        },
        initialTab:
            (todayIndex != -1 && getLectures(reorderedDates[todayIndex]).isNotEmpty)
            ? todayIndex
            : reorderedDates.indexWhere(
                (date) =>
                    date.isAfter(now) &&
                    getLectures(date).isNotEmpty,
              ),
        tabEnabled: tabEnabled,
      ),
    );
  }
}
