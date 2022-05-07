import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/schedule_planner_card.dart';

class ClassRegistrationScheduleEditorPageView extends StatefulWidget {
  final String scheduleOption;

  const ClassRegistrationScheduleEditorPageView(this.scheduleOption, {Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorPageViewState createState() =>
      _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption);
}

class _ClassRegistrationScheduleEditorPageViewState
    extends SecondaryPageViewState {
  final String scheduleOption;

  _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption) : super();

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Map<String, List<String>>>(
      converter: (store) {
        // TODO get classes from appstate
        final Map<String, List<String>> classes = {
          'PI': ['a', 'b', 'c'],
          'IA': ['a', 'b', 'c'],
          'CPD': ['a', 'b', 'c'],
          'ESOF': ['a', 'b', 'c'],
          'C': ['a', 'b', 'c'],
        };

        return classes;
      },
      builder: (context, classes) {
        return _ClassRegistrationScheduleEditorView(
            scheduleOption: this.scheduleOption, classes: classes);
      },
    );
  }
}

class _ClassRegistrationScheduleEditorView extends StatefulWidget {
  final Map<String, List<String>> classes;
  final String scheduleOption;

  const _ClassRegistrationScheduleEditorView(
      {this.scheduleOption, this.classes, Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorViewState createState() =>
      _ClassRegistrationScheduleEditorViewState(
          this.scheduleOption, this.classes);
}

class _ClassRegistrationScheduleEditorViewState
    extends State<_ClassRegistrationScheduleEditorView> {
  final Map<String, List<String>> classes;
  final String scheduleOption;
  TextEditingController _renameController;
  List<PageStorageKey<_ClassRegistrationScheduleEditorViewState>>
      _expandableKeys;

  _ClassRegistrationScheduleEditorViewState(this.scheduleOption, this.classes) {
    _expandableKeys = [for (String _ in classes.keys) PageStorageKey(this)];
  }

  @override
  void initState() {
    super.initState();
    _renameController = TextEditingController(text: this.scheduleOption);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      PageTitle(name: 'Planeador de Horário'),
      SizedBox(height: 20),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome da opção',
              ),
              controller: _renameController, // TODO schedule option rename
            )),
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.file_copy_outlined),
              onPressed: () => {/* TODO copy */},
            ),
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.delete_outline),
              onPressed: () => {/* TODO delete */},
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      for (int i = 0; i < classes.keys.length; i++)
        buildCourseDropdown(i, context),
      SizedBox(height: 20),
      Column(
        children: <Widget>[
          ElevatedButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {/* TODO save */},
            child: Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    ]);
  }

  Widget buildCourseDropdown(int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ExpansionTile(
        key: _expandableKeys[index],
        title: Text(classes.keys.elementAt(index)),
        subtitle: Text('3LEIC02'),
        children: <Widget>[
          ListTile(title: Text('3LEIC01'), onTap: () {}),
          ListTile(title: Text('3LEIC02')),
          ListTile(title: Text('3LEIC03')),
          ListTile(title: Text('3LEIC04')),
        ],
      ),
    );
  }
}
