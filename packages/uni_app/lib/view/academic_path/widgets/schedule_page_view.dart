import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/academic_schedule_card.dart';
import 'package:uni/view/academic_path/widgets/empty_week.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class SchedulePageView extends StatefulWidget {
  SchedulePageView(this.lectures, {required DateTime now, super.key})
      : currentWeek = Week(start: now);

  final List<Lecture> lectures;
  final Week currentWeek;

  @override
  SchedulePageViewState createState() => SchedulePageViewState();
}

class SchedulePageViewState extends State<SchedulePageView> {
  late List<DateTime> reorderedDates;
  late int initialTab;

  @override
  void initState() {
    super.initState();
    reorderedDates = _getReorderedWeekDates(widget.currentWeek.start);
    final today = widget.currentWeek.start;

    initialTab = reorderedDates.indexWhere(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final noLectures =
        _lecturesOfWeek(widget.lectures, widget.currentWeek).isEmpty;
    return Timeline(
      tabs: createTabs(context),
      content: noLectures ? [const EmptyWeek()] : createTabViewBuilder(context),
      initialTab: initialTab,
    );
  }

  List<Widget> createTabs(BuildContext context) {
    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();

    // Reorder the days of the week to start with Sunday
    final reorderedDaysOfTheWeek = [
      daysOfTheWeek[6], // Sunday (index 6 in default order)
      ...daysOfTheWeek.sublist(0, 6), // Monday to Saturday
    ];

    return List.generate(7, (index) {
      return Tab(
        key: Key('schedule-page-tab-$index'),
        height: 32,
        child: SizedBox(
          width: 26,
          height: 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                reorderedDaysOfTheWeek[index].substring(0, 3),
              ),
              Text(
                '${reorderedDates[index].day}',
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> createTabViewBuilder(BuildContext context) {
    return List.generate(7, (index) {
      final day = reorderedDates[index];
      final lectures = _lecturesOfDay(widget.lectures, day);

      return ScheduleDayTimeline(
        key: Key('schedule-page-day-view-${day.weekday}'),
        day: day,
        lectures: lectures,
      );
    });
  }

  List<DateTime> _getReorderedWeekDates(DateTime startOfWeek) {
    final sunday =
        startOfWeek.subtract(Duration(days: startOfWeek.weekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  List<Lecture> _lecturesOfWeek(List<Lecture> lectures, Week currentWeek) {
    final startOfWeek = currentWeek.start;
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return lectures.where((lecture) {
      final startTime = lecture.startTime;
      return startTime.isAfter(startOfWeek) && startTime.isBefore(endOfWeek);
    }).toList();
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
