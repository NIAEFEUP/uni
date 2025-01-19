import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';
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

class SchedulePageViewState extends State<SchedulePageView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<DateTime> reorderedDates;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 7); // Fixed to 7 days
    reorderedDates = _getReorderedWeekDates(widget.currentWeek.start);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
      final isSelected = tabController.index == index;
      return Tab(
        key: Key('schedule-page-tab-$index'),
        height: 50,
        child: Container(
          width: 45,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(177, 77, 84, 0.25)
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                toShortVersion(reorderedDaysOfTheWeek[index]),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isSelected
                      ? const Color.fromRGBO(102, 9, 16, 1)
                      : const Color.fromRGBO(48, 48, 48, 1),
                ),
              ),
              Text(
                '${reorderedDates[index].day}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isSelected
                      ? const Color.fromRGBO(102, 9, 16, 1)
                      : const Color.fromRGBO(48, 48, 48, 1),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String toShortVersion(String dayOfTheWeek) {
    String shortVersion;
    switch (dayOfTheWeek) {
      case 'Monday':
        shortVersion = 'Mon';
      case 'Tuesday':
        shortVersion = 'Tue';
      case 'Wednesday':
        shortVersion = 'Wed';
      case 'Thursday':
        shortVersion = 'Thu';
      case 'Friday':
        shortVersion = 'Fri';
      case 'Saturday':
        shortVersion = 'Sat';
      case 'Sunday':
        shortVersion = 'Sun';
      default:
        shortVersion = 'Blank';
    }
    return shortVersion;
  }

  List<DateTime> _getReorderedWeekDates(DateTime startOfWeek) {
    final sunday =
        startOfWeek.subtract(Duration(days: startOfWeek.weekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  List<Widget> createTabViewBuilder(BuildContext context) {
    return reorderedDates.map((day) {
      final lectures = lecturesOfDay(widget.lectures, day);
      final index = day.weekday % 7; // Map Sunday (7) to 0, etc.

      return lectures.isEmpty
          ? emptyDayColumn(context, index)
          : dayColumnBuilder(index, lectures);
    }).toList();
  }

  Widget dayColumnBuilder(int day, List<Lecture> lectures) {
    return ListView(
      key: Key('schedule-page-day-column-$day'),
      children: lectures
          .map(
            (lecture) => ScheduleSlot(
              subject: lecture.subject,
              typeClass: lecture.typeClass,
              rooms: lecture.room,
              begin: lecture.startTime,
              end: lecture.endTime,
              occurrId: lecture.occurrId,
              teacher: lecture.teacher,
              classNumber: lecture.classNumber,
            ),
          )
          .toList(),
    );
  }

  Widget emptyDayColumn(BuildContext context, int day) {
    final weekday =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale()[day];

    final noClassesText = S.of(context).no_classes_on;

    return Center(
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: '$noClassesText $weekday.',
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
