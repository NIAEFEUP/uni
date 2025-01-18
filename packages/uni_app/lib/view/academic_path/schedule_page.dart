import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/model/utils/time/weekday_mapper.dart';
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
  late List<Lecture> lecturesThisWeek;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 6);

    var weekDay = widget.currentWeek.start.weekday;

    lecturesThisWeek = <Lecture>[];
    widget.currentWeek.weekdays.take(6).forEach((day) {
      final lectures = lecturesOfDay(widget.lectures, day);
      lecturesThisWeek.addAll(lectures);
    });

    if (lecturesThisWeek.isNotEmpty) {
      final now = DateTime.now();

      final nextLecture = lecturesThisWeek
          .where((lecture) => lecture.endTime.isAfter(now))
          .fold<Lecture?>(null, (closest, lecture) {
        if (closest == null) {
          return lecture;
        }
        return lecture.endTime.difference(now) < closest.endTime.difference(now)
            ? lecture
            : closest;
      });

      if (nextLecture != null) {
        weekDay = nextLecture.endTime.weekday;
      }
    }

    final offset = (weekDay > 6) ? 0 : (weekDay - 1) % 6;
    tabController.animateTo(tabController.index + offset);
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
    final workWeekDays = Provider.of<LocaleNotifier>(context)
        .getWeekdaysWithLocale()
        .sublist(0, 6);
    final tabs = <Widget>[];
    for (var i = 0; i < DayOfWeek.values.length - 1; i++) {
      tabs.add(
        Tab(
          key: Key('schedule-page-tab-$i'),
          height: 50,
          child: AnimatedBuilder(
            animation: tabController,
            builder: (context, child) {
              final isSelected = tabController.index == i;

              return Container(
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
                      toShortVersion(workWeekDays[i]),
                      style: isSelected
                          ? const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(102, 9, 16, 1),
                            )
                          : const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(48, 48, 48, 1),
                            ),
                    ),
                    Text(
                      '$i',
                      style: isSelected
                          ? const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(102, 9, 16, 1),
                            )
                          : const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(48, 48, 48, 1),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
    return tabs;
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

  List<Widget> createTabViewBuilder(BuildContext context) {
    return widget.currentWeek.weekdays.take(6).map((day) {
      final lectures = lecturesOfDay(lecturesThisWeek, day);
      final index = WeekdayMapper.fromDartToIndex.map(day.weekday);
      if (lectures.isEmpty) {
        return emptyDayColumn(context, index);
      } else {
        return dayColumnBuilder(index, lectures);
      }
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

    final noClassesText = day >= DateTime.saturday - 1
        ? S.of(context).no_classes_on_weekend
        : S.of(context).no_classes_on;

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
