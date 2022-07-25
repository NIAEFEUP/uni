import 'package:flutter/material.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Common/page_title.dart';
import 'package:uni/view/Common/request_dependent_widget_builder.dart';
import 'package:uni/view/Pages/Schedule/widgets/schedule_slot.dart';

/// Manages the 'schedule' sections of the app
class SchedulePageView extends StatelessWidget {
  const SchedulePageView({
    Key? key,
    required this.tabController,
    required this.daysOfTheWeek,
    required this.aggLectures,
    required this.scheduleStatus,
  }) : super(key: key);

  final List<String> daysOfTheWeek;
  final List<List<Lecture>> aggLectures;
  final RequestStatus scheduleStatus;
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          const PageTitle(name: constants.navSchedule),
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
        children: createSchedule(context),
      ))
    ]);
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = <Widget>[];
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(SizedBox(
        width: queryData.size.width * 1 / 4,
        child: Tab(key: Key('schedule-page-tab-$i'), text: daysOfTheWeek[i]),
      ));
    }
    return tabs;
  }

  List<Widget> createSchedule(context) {
    final List<Widget> tabBarViewContent = <Widget>[];
    for (int i = 0; i < daysOfTheWeek.length; i++) {
      tabBarViewContent.add(createScheduleByDay(context, i));
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
        begin: lecture.startTime,
        end: lecture.endTime,
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

  Widget createScheduleByDay(BuildContext context, int day) {
    return RequestDependentWidgetBuilder(
      context: context,
      status: scheduleStatus,
      contentGenerator: dayColumnBuilder(day),
      content: aggLectures[day],
      contentChecker: aggLectures[day].isNotEmpty,
      onNullContent:
          Center(child: Text('Não possui aulas à ${daysOfTheWeek[day]}.')),
    );
  }
}
