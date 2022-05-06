import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
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
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {
        // TODO get items from appstate
        final List<String> items =
            List<String>.generate(6, (int index) => 'Novo horário $index');

        return items;
      },
      builder: (context, scheduleOptions) {
        return _ClassRegistrationView(scheduleOptions: scheduleOptions);
      },
    );
  }
}

class _ClassRegistrationView extends StatefulWidget {
  final List<String> scheduleOptions;

  const _ClassRegistrationView({this.scheduleOptions, Key key})
      : super(key: key);

  @override
  _ClassRegistrationViewState createState() =>
      _ClassRegistrationViewState(this.scheduleOptions);
}

class _ClassRegistrationViewState extends State<_ClassRegistrationView> {
  final List<String> scheduleOptions;

  _ClassRegistrationViewState(this.scheduleOptions);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      SchedulePlannerCard(
          items: scheduleOptions,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              // TODO reorder schedule
              final String item = scheduleOptions.removeAt(oldIndex);
              scheduleOptions.insert(newIndex, item);
            });
          }),
    ]);
  }
}
