import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/schedule_day_timeline.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class SchedulePageView extends StatelessWidget {
  SchedulePageView(this.lectures, {required DateTime now, super.key})
      : currentWeek = Week(start: now);

  final List<Lecture> lectures;
  final Week currentWeek;

  @override
  Widget build(BuildContext context) {
    final reorderedDates = _getReorderedWeekDates(currentWeek.start);
    final todayIndex = reorderedDates
        .indexWhere((date) => date.isAtSameMomentAs(currentWeek.start));
    final firstAvailableIndex = reorderedDates.indexWhere(
      (date) => _lecturesOfDay(lectures, date).isNotEmpty,
    );
    final lecturesToday =
        _lecturesOfDay(lectures, reorderedDates[todayIndex]).isNotEmpty;
    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final reorderedDaysOfTheWeek = [
      daysOfTheWeek[6],
      ...daysOfTheWeek.sublist(0, 6),
    ];
    final tabEnabled = reorderedDates
        .map((day) => _lecturesOfDay(lectures, day).isNotEmpty)
        .toList();

    return Timeline(
      tabs: reorderedDaysOfTheWeek
          .map(
            (day) => SizedBox(
              width: 30,
              height: 34,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      day.substring(0, 3),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${reorderedDates[reorderedDaysOfTheWeek.indexOf(day)].day}',
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
            (day) => ScheduleDayTimeline(
              key: Key('schedule-page-day-view-${day.weekday}'),
              day: day,
              lectures: _lecturesOfDay(lectures, day),
            ),
          )
          .toList(),
      initialTab: lecturesToday ? todayIndex : firstAvailableIndex,
      tabEnabled: tabEnabled,
    );
  }

  List<DateTime> _getReorderedWeekDates(DateTime startOfWeek) {
    final sunday =
        startOfWeek.subtract(Duration(days: startOfWeek.weekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  List<Lecture> _lecturesOfDay(List<Lecture> lectures, DateTime day) {
    return lectures.where((lecture) {
      final startTime = lecture.startTime;
      return startTime.year == day.year &&
          startTime.month == day.month &&
          startTime.day == day.day;
    }).toList();
  }
}
