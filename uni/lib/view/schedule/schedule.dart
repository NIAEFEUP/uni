import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return LazyConsumer<LectureProvider>(
      builder: (context, lectureProvider) {
        return SchedulePageView(
          lectures: lectureProvider.lectures,
          scheduleStatus: lectureProvider.status,
        );
      },
    );
  }
}

/// Manages the 'schedule' sections of the app
class SchedulePageView extends StatefulWidget {
  SchedulePageView(
      {super.key, required this.lectures, required this.scheduleStatus,});

  final List<dynamic>? lectures;
  final RequestStatus? scheduleStatus;

  final int weekDay = DateTime.now().weekday;

  static final List<String> daysOfTheWeek =
  TimeString.getWeekdaysStrings(includeWeekend: false);

  static List<Set<Lecture>> groupLecturesByDay(schedule) {
    final aggLectures = <Set<Lecture>>[];

    for (var i = 0; i < daysOfTheWeek.length; i++) {
      final lectures = <Lecture>{};
      for (var j = 0; j < schedule.length; j++) {
        if (schedule[j].startTime.weekday - 1 == i) lectures.add(schedule[j]);
      }
      aggLectures.add(lectures);
    }
    return aggLectures;
  }

  @override
  SchedulePageViewState createState() => SchedulePageViewState();
}

class SchedulePageViewState extends GeneralPageViewState<SchedulePageView>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        vsync: this, length: SchedulePageView.daysOfTheWeek.length,);
    final offset = (widget.weekDay > 5)
        ? 0
        : (widget.weekDay - 1) % SchedulePageView.daysOfTheWeek.length;
    tabController?.animateTo(tabController!.index + offset);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    final queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: DrawerItem.navSchedule.title),
          TabBar(
            controller: tabController,
            isScrollable: true,
            physics: const BouncingScrollPhysics(),
            tabs: createTabs(queryData, context),
          ),
        ],
      ),
      Expanded(
          child: TabBarView(
            controller: tabController,
            children:
            createSchedule(context, widget.lectures, widget.scheduleStatus),
          ),)
    ],);
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(queryData, BuildContext context) {
    final tabs = <Widget>[];
    for (var i = 0; i < SchedulePageView.daysOfTheWeek.length; i++) {
      tabs.add(SizedBox(
        width: queryData.size.width * 1 / 4,
        child: Tab(
            key: Key('schedule-page-tab-$i'),
            text: SchedulePageView.daysOfTheWeek[i],),
      ),);
    }
    return tabs;
  }

  List<Widget> createSchedule(
      context, List<dynamic>? lectures, RequestStatus? scheduleStatus,) {
    final tabBarViewContent = <Widget>[];
    for (var i = 0; i < SchedulePageView.daysOfTheWeek.length; i++) {
      tabBarViewContent
          .add(createScheduleByDay(context, i, lectures, scheduleStatus));
    }
    return tabBarViewContent;
  }

  /// Returns a list of widgets for the rows with a singular class info.
  List<Widget> createScheduleRows(lectures, BuildContext context) {
    final scheduleContent = <Widget>[];
    lectures = lectures.toList();
    for (var i = 0; i < lectures.length; i++) {
      final Lecture lecture = lectures[i];
      scheduleContent.add(ScheduleSlot(
        subject: lecture.subject,
        typeClass: lecture.typeClass,
        rooms: lecture.room,
        begin: lecture.startTime,
        end: lecture.endTime,
        occurrId: lecture.occurrId,
        teacher: lecture.teacher,
        classNumber: lecture.classNumber,
      ),);
    }
    return scheduleContent;
  }

  Widget dayColumnBuilder(int day, dayContent, BuildContext context) {
    return Container(
        key: Key('schedule-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createScheduleRows(dayContent, context),
        ),);
  }

  Widget createScheduleByDay(BuildContext context, int day,
      List<dynamic>? lectures, RequestStatus? scheduleStatus,) {
    final List aggLectures = SchedulePageView.groupLecturesByDay(lectures);
    return RequestDependentWidgetBuilder(
      status: scheduleStatus ?? RequestStatus.none,
      builder: () => dayColumnBuilder(day, aggLectures[day], context),
      hasContentPredicate: aggLectures[day].isNotEmpty,
        onNullContent: Center(
            child: ImageLabel(imagePath: 'assets/images/schedule.png', label: 'Não possui aulas à ${SchedulePageView.daysOfTheWeek[day]}.', labelTextStyle: const TextStyle(fontSize: 15),
            ),
        ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<LectureProvider>(context, listen: false)
        .forceRefresh(context);
  }
}



