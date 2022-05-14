import 'package:flutter_redux/flutter_redux.dart';
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
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, SchedulePreferenceList>(
      converter: (store) {
        // TODO get items from appstate
        return SchedulePreferenceList(
          preferences: List<ScheduleOption>.generate(6, (int index) =>
            ScheduleOption(
              name: 'Novo horário $index',
              classesSelected: Map(),
            )
          )
        );
      },
      builder: (context, schedulePreferences) {
        return _ClassRegistrationView(schedulePreferences: schedulePreferences);
      },
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

  _ClassRegistrationViewState(this.schedulePreferences);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      SchedulePlannerCard(
          items: schedulePreferences,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              // TODO update appstate
              schedulePreferences.reorder(oldIndex, newIndex);
            });
          }),
    ]);
  }
}
