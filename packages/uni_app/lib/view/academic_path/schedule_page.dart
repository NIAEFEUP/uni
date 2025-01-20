import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/timeline/timeline.dart';

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
          builder: (context, lectures) => SchedulePageView(
            lectures,
            now: widget.now,
          ),
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

  @override
  void initState() {
    super.initState();
    reorderedDates = _getReorderedWeekDates(widget.currentWeek.start);
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(
      tabs: createTabs(context),
      content: createTabViewBuilder(context),
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
      final lectures =
          getMockLectures(); // lecturesOfDay(widget.lectures, day);

      return lectures.isEmpty
          ? emptyDayColumn(context, day)
          : dayColumnBuilder(day, lectures);
    });
  }

  Widget dayColumnBuilder(DateTime day, List<Lecture> lectures) {
    return Column(
      key: Key(
        'schedule-page-day-column-${day.weekday}',
      ),
      children: lectures
          .map(
            (lecture) => ScheduleCard(
              name: lecture.subject,
              acronym: _getAcronym(lecture.subject),
              room: lecture.room,
              type: lecture.typeClass,
              isActive: _isLectureActive(lecture),
              teacherName: lecture.teacher,
            ),
          )
          .toList(),
    );
  }

  String _getAcronym(String subject) {
    return subject.split(' ').map((word) => word[0]).join().toUpperCase();
  }

  bool _isLectureActive(Lecture lecture) {
    final now = DateTime.now();
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }

  Widget emptyDayColumn(BuildContext context, DateTime day) {
    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final weekdayName = daysOfTheWeek[(day.weekday - 1) % 7];

    final noClassesText = S.of(context).no_classes_on;

    return Center(
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: '$noClassesText $weekdayName.',
        labelTextStyle: const TextStyle(fontSize: 15),
      ),
    );
  }

  static List<Lecture> lecturesOfDay(List<Lecture> lectures, DateTime day) {
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
      DateTime.now().add(const Duration(days: 1, hours: 1)),
      DateTime.now().add(const Duration(days: 1, hours: 2)),
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
  ];
}
