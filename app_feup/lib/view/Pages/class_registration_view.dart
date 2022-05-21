import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/schedule_planner_card.dart';

class ClassRegistrationPageView extends StatefulWidget {
  const ClassRegistrationPageView({Key key}) : super(key: key);

  @override
  _ClassRegistrationPageViewState createState() =>
      _ClassRegistrationPageViewState();
}

class _ClassRegistrationPageViewState extends SecondaryPageViewState {
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  Future<List<ScheduleOption>> options;

  @override
  void initState() {
    super.initState();
    options = db.getScheduleOptions();
  }

  @override
  Widget getBody(BuildContext context) {

    return FutureBuilder<List<ScheduleOption>>(
        future: this.options,
        builder: (
            BuildContext innerContext,
            AsyncSnapshot<List<ScheduleOption>> snapshot) {
          if (snapshot.hasData) {
                return _ClassRegistrationView(
                    schedulePreferences: SchedulePreferenceList(
                        preferences: snapshot.data
                    )
                );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              )],
            ),
          );
        }
    );
  }
}

class _ClassRegistrationView extends StatefulWidget {
  final SchedulePreferenceList schedulePreferences;

  const _ClassRegistrationView({this.schedulePreferences, Key key})
      : super(key: key);

  @override
  _ClassRegistrationViewState createState() =>
      _ClassRegistrationViewState(this.schedulePreferences);
}

class _ClassRegistrationViewState extends State<_ClassRegistrationView> {
  final SchedulePreferenceList schedulePreferences;
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();

  _ClassRegistrationViewState(this.schedulePreferences);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      SchedulePlannerCard(
          items: schedulePreferences,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              schedulePreferences.reorder(oldIndex, newIndex);
              db.reorderOptions(schedulePreferences.preferences);
            });
          }),
    ]);
  }
}
