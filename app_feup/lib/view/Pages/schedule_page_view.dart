import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

class SchedulePageView extends StatefulWidget {
  SchedulePageView(
      {Key key,
      @required this.daysOfTheWeek,
      @required this.aggLectures,
      @required this.scheduleStatus});

  final List<String> daysOfTheWeek;
  final List<List<Lecture>> aggLectures;
  final RequestStatus scheduleStatus;

  @override
  State<StatefulWidget> createState() => SchedulePageViewState(
      daysOfTheWeek: daysOfTheWeek,
      aggLectures: aggLectures,
      scheduleStatus: scheduleStatus);
}

class SchedulePageViewState extends SecondaryPageViewState 
    with SingleTickerProviderStateMixin  {
  SchedulePageViewState(
      {Key key,
      @required this.daysOfTheWeek,
      @required this.aggLectures,
      @required this.scheduleStatus});

  final List<String> daysOfTheWeek;
  final List<List<Lecture>> aggLectures;
  final RequestStatus scheduleStatus;
  TabController tabController;
  final int weekDay = DateTime.now().weekday;

  
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: daysOfTheWeek.length);
    final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
  }
    
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final Color labelColor = Color.fromARGB(255, 0x50, 0x50, 0x50);

    return Column(children: <Widget>[
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: 'Horário'),
          TabBar(
            controller: tabController,
            unselectedLabelColor: labelColor,
            labelColor: labelColor,
            isScrollable: true,
            indicatorWeight: 3.0,
            indicatorColor: Theme.of(context).primaryColor,
            labelPadding: EdgeInsets.all(0.0),
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

  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = <Widget>[];
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        width: queryData.size.width * 1 / 3,
        child: Tab(
          key: Key('schedule-page-tab-$i'),
          text: daysOfTheWeek[i]),
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
        teacher: lecture.teacher,
        classNumber: lecture.classNumber,
      ));
    }
    return scheduleContent;
  }

  Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(
      int day) {
    Widget createDayColumn(dayContent, BuildContext context) {
      return ListView(          
          key: Key('schedule-page-day-column-$day'),
          controller: scrollViewController,
          children: createScheduleRows(dayContent, context));
    }
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
          Center(child: Text('Não possui aulas à ' + daysOfTheWeek[day] + '.')),
    );
  }
}
