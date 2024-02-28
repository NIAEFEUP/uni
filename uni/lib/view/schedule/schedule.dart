import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends SecondaryPageViewState<SchedulePage> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => SchedulePageView(lectures),
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: const SchedulePageView([]),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    await context.read<LectureProvider>().forceRefresh(context);
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navSchedule.route);
}

class SchedulePageView extends StatefulWidget {
  const SchedulePageView(this.lectures, {super.key});

  final List<Lecture> lectures;

  @override
  SchedulePageViewState createState() => SchedulePageViewState();
}

class SchedulePageViewState extends State<SchedulePageView>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 6,
    );
    final weekDay = DateTime.now().weekday;
    final offset = (weekDay > 6) ? 0 : (weekDay - 1) % 6;
    tabController?.animateTo(tabController!.index + offset);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          tabs: createTabs(queryData, context),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: Iterable<int>.generate(6).map((day) {
              final lectures = lecturesOfDay(widget.lectures, day);
              if (lectures.isEmpty) {
                return emptyDayColumn(context, day);
              } else {
                return dayColumnBuilder(day, lectures, context);
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(MediaQueryData queryData, BuildContext context) {
    final tabs = <Widget>[];
    final workWeekDays =
        context.read<LocaleNotifier>().getWeekdaysWithLocale().sublist(0, 6);
    workWeekDays.asMap().forEach((index, day) {
      tabs.add(
        SizedBox(
          width: (queryData.size.width * 1) / 4,
          child: Tab(
            key: Key('schedule-page-tab-$index'),
            text: day,
          ),
        ),
      );
    });
    return tabs;
  }

  Widget dayColumnBuilder(
    int day,
    List<Lecture> lectures,
    BuildContext context,
  ) {
    return Container(
      key: Key('schedule-page-day-column-$day'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: lectures
            .map(
              // TODO(thePeras): ScheduleSlot should receive a lecture
              //  instead of all these parameters.
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
      ),
    );
  }

  static List<Lecture> lecturesOfDay(List<Lecture> lectures, int day) {
    final filteredLectures = <Lecture>[];
    for (var i = 0; i < lectures.length; i++) {
      if (lectures[i].startTime.weekday - 1 == day) {
        filteredLectures.add(lectures[i]);
      }
    }
    return filteredLectures;
  }

  Widget emptyDayColumn(BuildContext context, int day) {
    final weekday =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale()[day];

    return Center(
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: '${S.of(context).no_classes_on} $weekday.',
        labelTextStyle: const TextStyle(fontSize: 15),
      ),
    );
  }
}
