import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      constraints: BoxConstraints(maxHeight: 150.0),
      child: Material(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class SchedulePageView extends StatefulWidget {
  SchedulePageView(
      {Key key,
      @required this.tabController,
      @required this.scrollViewController,
      @required this.daysOfTheWeek,
      @required this.aggLectures});

  final List<String> daysOfTheWeek;
  final List<List<Lecture>> aggLectures;
  final TabController tabController;
  final ScrollController scrollViewController;

  @override
  State<StatefulWidget> createState() => SchedulePageViewState(
      tabController: tabController,
      scrollViewController: scrollViewController,
      daysOfTheWeek: daysOfTheWeek,
      aggLectures: aggLectures);
}

class SchedulePageViewState extends SecondaryPageViewState {
  SchedulePageViewState(
      {Key key,
      @required this.tabController,
      @required this.scrollViewController,
      @required this.daysOfTheWeek,
      @required this.aggLectures});

  final List<String> daysOfTheWeek;
  final List<List<Lecture>> aggLectures;
  final TabController tabController;
  final ScrollController scrollViewController;

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final Color labelColor = Color.fromARGB(255, 0x50, 0x50, 0x50);

    return Column(
      children: <Widget>[
        PageTitle(name: 'Horário'),
        Expanded(
          child: NestedScrollView(
            controller: scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: tabController,
                      isScrollable: true,
                      unselectedLabelColor: labelColor,
                      labelColor: labelColor,
                      indicatorWeight: 3.0,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelPadding: EdgeInsets.all(0.0),
                      tabs: createTabs(queryData, context),
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: createSchedule(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = List<Widget>();
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        width: queryData.size.width * 1 / 3,
        child: Tab(text: daysOfTheWeek[i]),
      ));
    }
    return tabs;
  }

  List<Widget> createSchedule(context) {
    final List<Widget> tabBarViewContent = List<Widget>();
    for (int i = 0; i < daysOfTheWeek.length; i++) {
      tabBarViewContent.add(createScheduleByDay(context, i));
    }
    return tabBarViewContent;
  }

  List<Widget> createScheduleRows(lectures, BuildContext context) {
    final List<Widget> scheduleContent = List<Widget>();
    for (int i = 0; i < lectures.length; i++) {
      final Lecture lecture = lectures[i];
      scheduleContent.add(ScheduleSlot(
        subject: lecture.subject,
        typeClass: lecture.typeClass,
        rooms: lecture.room,
        begin: lecture.startTime,
        end: lecture.endTime,
        teacher: lecture.teacher,
        //classNumber: lecture.,
      ));
    }
    return scheduleContent;
  }

  Widget createDayColumn(dayContent, BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: createScheduleRows(dayContent, context),
    ));
  }

  Widget createScheduleByDay(BuildContext context, day) {
    return StoreConnector<AppState, RequestStatus>(
        converter: (store) => store.state.content['scheduleStatus'],
        builder: (context, status) => RequestDependentWidgetBuilder(
              context: context,
              status: status,
              contentGenerator: createDayColumn,
              content: aggLectures[day],
              contentChecker: aggLectures[day].isNotEmpty,
              onNullContent: Center(
                  child:
                      Text('Não possui aulas à ' + daysOfTheWeek[day] + '.')),
            ));
  }
}
