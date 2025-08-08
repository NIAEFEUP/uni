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

    final daysOfTheWeek =
        ref.read(localeProvider.notifier).getWeekdaysWithLocale();

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

    return Timeline(
      tabs:
          reorderedDates
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
      content:
          reorderedDates
              .map(
                (date) => ScheduleDayTimeline(
                  key: Key('schedule-page-day-view-${date.weekday}'),
                  now: now,
                  day: date,
                  lectures: _lecturesOfDay(lectures, date),
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
      tabEnabled:
          reorderedDates
              .map((date) => _lecturesOfDay(lectures, date).isNotEmpty)
              .toList(),
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
