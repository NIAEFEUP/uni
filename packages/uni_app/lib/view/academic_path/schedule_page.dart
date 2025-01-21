import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/academic_schedule_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/schedule_timeline.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<LectureProvider>().forceRefresh(context);
        },
        child: LazyConsumer<LectureProvider, List<Lecture>>(
          builder: (context, lectures) {
            final mockLectures = getMockLectures();
            return SchedulePageView(
              mockLectures,
              now: widget.now,
            );
          },
          hasContent: (lectures) => lectures.isNotEmpty,
          onNullContent: SchedulePageView(const [], now: widget.now),
        ),
      ),
    );
  }
}

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
  late int initialTabIndex;

  @override
  void initState() {
    super.initState();
    reorderedDates = _getReorderedWeekDates(widget.currentWeek.start);
    final today = widget.currentWeek.start;

    initialTabIndex = reorderedDates.indexWhere(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScheduleTimeline(
      tabs: createTabs(context),
      content: createTabViewBuilder(context),
      initialTabIndex: initialTabIndex,
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
        height: 35,
        child: SizedBox(
          width: 26,
          height: 35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                reorderedDaysOfTheWeek[index].substring(0, 3),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${reorderedDates[index].day}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<DateTime> _getReorderedWeekDates(DateTime startOfWeek) {
    final sunday =
        startOfWeek.subtract(Duration(days: startOfWeek.weekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  List<Widget> createTabViewBuilder(BuildContext context) {
    return List.generate(7, (index) {
      final day = reorderedDates[index];
      final lectures = lecturesOfDay(widget.lectures, day);

      return ScheduleDayTimeline(
        key: Key('schedule-page-day-view-${day.weekday}'),
        day: day,
        lectures: lectures,
      );
    });
  }

  List<Lecture> lecturesOfDay(List<Lecture> lectures, DateTime day) {
    final filteredLectures = <Lecture>[];
    for (var i = 0; i < lectures.length; i++) {
      final lecture = lectures[i];
      if (lecture.startTime.day == day.day &&
          lecture.startTime.month == day.month &&
          lecture.startTime.year == day.year) {
        filteredLectures.add(lecture);
      }
    }
    return filteredLectures;
  }
}

List<Lecture> getMockLectures() {
  return [
    Lecture(
      'Mathematics',
      'Lecture',
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 1)),
      '101',
      'Dr. Smith',
      'Class 1',
      1,
    ),
    Lecture(
      'Physics',
      'Lecture',
      DateTime.now().add(const Duration(hours: 2)),
      DateTime.now().add(const Duration(hours: 3)),
      '102',
      'Dr. Johnson',
      'Class 2',
      2,
    ),
    Lecture(
      'Chemistry',
      'Lab',
      DateTime.now().add(const Duration(hours: 5)),
      DateTime.now().add(const Duration(hours: 6)),
      'Lab 201',
      'Dr. Brown',
      'Class 3',
      3,
    ),
    Lecture(
      'Biology',
      'Lecture',
      DateTime.now().add(const Duration(days: 2, hours: 3)),
      DateTime.now().add(const Duration(days: 2, hours: 4)),
      '103',
      'Dr. Taylor',
      'Class 4',
      4,
    ),
    Lecture(
      'Computer Science',
      'Lecture',
      DateTime.now().add(const Duration(days: 3, hours: 4)),
      DateTime.now().add(const Duration(days: 3, hours: 5)),
      '104',
      'Dr. Martinez',
      'Class 5',
      5,
    ),
    Lecture(
      'Philosophy',
      'Lecture',
      DateTime.now().add(const Duration(days: 4, hours: 5)),
      DateTime.now().add(const Duration(days: 4, hours: 6)),
      '105',
      'Dr. Lee',
      'Class 6',
      6,
    ),
    Lecture(
      'History',
      'Lecture',
      DateTime.now().add(const Duration(days: 5, hours: 6)),
      DateTime.now().add(const Duration(days: 5, hours: 7)),
      '106',
      'Dr. Williams',
      'Class 7',
      7,
    ),
    Lecture(
      'Geography',
      'Lab',
      DateTime.now().add(const Duration(days: 6, hours: 7)),
      DateTime.now().add(const Duration(days: 6, hours: 8)),
      '107',
      'Dr. Harris',
      'Class 8',
      8,
    ),
  ];
}
