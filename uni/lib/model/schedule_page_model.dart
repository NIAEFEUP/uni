import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/Pages/Schedule/schedule.dart';
import 'package:uni/view/PagesLayouts/Secondary/secondary.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends SecondaryPageViewState<SchedulePage>
    with SingleTickerProviderStateMixin {
  final int weekDay = DateTime.now().weekday;

  late TabController tabController;

  final List<String> daysOfTheWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  List<List<Lecture>> _groupLecturesByDay(schedule) {
    final aggLectures = <List<Lecture>>[];

    for (int i = 0; i < daysOfTheWeek.length; i++) {
      final List<Lecture> lectures = <Lecture>[];
      for (int j = 0; j < schedule.length; j++) {
        if (schedule[j].day == i) lectures.add(schedule[j]);
      }
      aggLectures.add(lectures);
    }
    return aggLectures;
  }

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
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>?>(
      converter: (store) => Tuple2(store.state.content['schedule'],
          store.state.content['scheduleStatus']),
      builder: (context, lectureData) {
        final lectures = lectureData?.item1;
        final scheduleStatus = lectureData?.item2;
        return SchedulePageView(
            tabController: tabController,
            daysOfTheWeek: daysOfTheWeek,
            aggLectures: _groupLecturesByDay(lectures),
            scheduleStatus: scheduleStatus ?? RequestStatus.none);
      },
    );
  }
}
