import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/schedule_planner_card.dart';

class ClassRegistrationScheduleEditorPageView extends StatefulWidget {
  final ScheduleOption scheduleOption;

  const ClassRegistrationScheduleEditorPageView(this.scheduleOption, {Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorPageViewState createState() =>
      _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption);
}

class _ClassRegistrationScheduleEditorPageViewState
    extends SecondaryPageViewState {
  final ScheduleOption scheduleOption;

  _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption) : super();

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, CourseUnitsForClassRegistration>(
      converter: (store) {
        // TODO get classes from appstate
        return CourseUnitsForClassRegistration(selected: [
          CourseUnit(
              name: 'Engenharia de Software',
              abbreviation: 'ESOF',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture('ESOF', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ESOF', 'TP', 2, 4, 'B115', 'ASL', '3LEIC01', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture('ESOF', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ESOF', 'TP', 1, 4, 'B343', 'FFC', '3LEIC02', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture('ESOF', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ESOF', 'TP', 1, 4, 'B206', 'AOR', '3LEIC03', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture('ESOF', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ESOF', 'TP', 2, 4, 'B310', 'ASL', '3LEIC04', 10, 30,
                      12, 30),
                ]),
              ]),
          CourseUnit(
              name: 'Inteligência Artificial',
              abbreviation: 'IA',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 2, 4, 'B342', 'HCL', '3LEIC01', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 2, 4, 'B217', 'APR', '3LEIC02', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 1, 4, 'B206', 'NRSG', '3LEIC03', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 1, 4, 'B202', 'NRSG', '3LEIC04', 8, 30,
                      10, 30),
                ]),
              ]),
          CourseUnit(
              name: 'Computação Paralela e Distribuída',
              abbreviation: 'CPD',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B342', 'PFS+JGB', '3LEIC01', 8,
                      30, 10, 30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B343', 'SCS1', '3LEIC02', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 2, 4, 'B205', 'PMAADO', '3LEIC03', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B202', 'AJMC', '3LEIC04', 10, 30,
                      12, 30),
                ]),
              ]),
          CourseUnit(name: 'Compiladores', abbreviation: 'C', classes: [
            CourseUnitClass(name: '3LEIC01', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 1, 4, 'B342', 'AMSMF', '3LEIC01', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC02', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B217', 'LGBC', '3LEIC02', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC03', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B205', 'PMSP', '3LEIC03', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC04', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B310', 'PMSP', '3LEIC04', 8, 30, 10, 30),
            ]),
          ]),
        ]);
      },
      builder: (context, course_units) {
        return _ClassRegistrationScheduleEditorView(
            scheduleOption: this.scheduleOption, courseUnits: course_units);
      },
    );
  }
}

class _ClassRegistrationScheduleEditorView extends StatefulWidget {
  final CourseUnitsForClassRegistration courseUnits;
  final ScheduleOption scheduleOption;

  const _ClassRegistrationScheduleEditorView(
      {this.scheduleOption, this.courseUnits, Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorViewState createState() =>
      _ClassRegistrationScheduleEditorViewState(
          this.scheduleOption, this.courseUnits);
}

class _ClassRegistrationScheduleEditorViewState
    extends State<_ClassRegistrationScheduleEditorView> {
  final CourseUnitsForClassRegistration courseUnits;
  final ScheduleOption scheduleOption;

  TextEditingController _renameController;
  List<PageStorageKey<_ClassRegistrationScheduleEditorViewState>>
      _expandableKeys;

  _ClassRegistrationScheduleEditorViewState(
      this.scheduleOption, this.courseUnits) {
    _expandableKeys = [
      for (CourseUnit _ in courseUnits.selected) PageStorageKey(this)
    ];
  }

  @override
  void initState() {
    super.initState();
    _renameController = TextEditingController(text: this.scheduleOption.name);
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
      for (int i = 0; i < courseUnits.selected.length; i++)
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
        title: Text(courseUnits.selected[index].name),
        subtitle: Text('3LEIC01'),
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
