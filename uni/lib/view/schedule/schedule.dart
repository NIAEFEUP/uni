import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/utils/drawer_items.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>?>(
      converter: (store) => Tuple2(store.state.content['schedule'],
          store.state.content['scheduleStatus']),
      builder: (context, lectureData) {
        final lectures = lectureData?.item1;
        final scheduleStatus = lectureData?.item2;
        return SchedulePageView(
          lectures: lectures,
          scheduleStatus: scheduleStatus,
        );
      },
    );
  }
}

/// Manages the 'schedule' sections of the app
class SchedulePageView extends StatefulWidget {
  SchedulePageView(
      {Key? key, required this.lectures, required this.scheduleStatus})
      : super(key: key);

  final List<dynamic>? lectures;
  final RequestStatus? scheduleStatus;

  final int weekDay = DateTime.now().weekday;

  static final List<String> daysOfTheWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  static List<List<Lecture>> groupLecturesByDay(schedule) {
    final aggLectures = <List<Lecture>>[];

    for (int i = 0; i < daysOfTheWeek.length; i++) {
      final List<Lecture> lectures = <Lecture>[];
      for (int j = 0; j < schedule.length; j++) {
        if (schedule[j].startTime.weekday-1 == i) lectures.add(schedule[j]);
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
        vsync: this, length: SchedulePageView.daysOfTheWeek.length);
    final offset = (widget.weekDay > 5)
        ? 0
        : (widget.weekDay - 1) % SchedulePageView.daysOfTheWeek.length;
    tabController?.animateTo((tabController!.index + offset));
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
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
      ))
    ]);
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = <Widget>[];
    for (var i = 0; i < SchedulePageView.daysOfTheWeek.length; i++) {
      tabs.add(SizedBox(
        width: queryData.size.width * 1 / 4,
        child: Tab(
            key: Key('schedule-page-tab-$i'),
            text: SchedulePageView.daysOfTheWeek[i]),
      ));
    }
    return tabs;
  }

  List<Widget> createSchedule(
      context, List<dynamic>? lectures, RequestStatus? scheduleStatus) {
    final List<Widget> tabBarViewContent = <Widget>[];
    for (int i = 0; i < SchedulePageView.daysOfTheWeek.length; i++) {
      tabBarViewContent
          .add(createScheduleByDay(context, i, lectures, scheduleStatus));
    }
    return tabBarViewContent;
  }

  /// Returns a list of widgets for the rows with a singular class info.
  List<Widget> createScheduleRows(lectures, BuildContext context) {
    final List<Widget> scheduleContent = <Widget>[];
    for (int i = 0; i < lectures.length; i++) {
      final Lecture lecture = lectures[i];
      scheduleContent.add(ScheduleSlot(
        subject: lecture.subject,
        typeClass: lecture.typeClass,
        rooms: lecture.room,
        begin: DateFormat("HH:mm").format(lecture.startTime),
        end: DateFormat("HH:mm").format(lecture.endTime),
        occurrId: lecture.occurrId,
        teacher: lecture.teacher,
        classNumber: lecture.classNumber,
      ));
    }
    return scheduleContent;
  }

  Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(
      int day) {
    Widget createDayColumn(dayContent, BuildContext context) {
      return Container(
          key: Key('schedule-page-day-column-$day'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: createScheduleRows(dayContent, context),
          ));
    }

    return createDayColumn;
  }

  Widget createScheduleByDay(BuildContext context, int day,
      List<dynamic>? lectures, RequestStatus? scheduleStatus) {
    final List aggLectures = SchedulePageView.groupLecturesByDay(lectures);
    return RequestDependentWidgetBuilder(
      context: context,
      status: scheduleStatus ?? RequestStatus.none,
      contentGenerator: dayColumnBuilder(day),
      content: aggLectures[day],
      contentChecker: aggLectures[day].isNotEmpty,
      onNullContent: Center(
          child: Text(
              'Não possui aulas à ${SchedulePageView.daysOfTheWeek[day]}.')),
    );
  }
}
