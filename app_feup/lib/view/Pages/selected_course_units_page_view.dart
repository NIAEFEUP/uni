import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';

class SelectedCourseUnitsPageView extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;

  const SelectedCourseUnitsPageView(this.selectedCourseUnits, {Key key})
      : super(key: key);

  @override
  _SelectedCourseUnitsPageViewState createState() =>
      _SelectedCourseUnitsPageViewState(this.selectedCourseUnits);
}

class _SelectedCourseUnitsPageViewState extends SecondaryPageViewState {
  final CourseUnitsForClassRegistration selectedCourseUnits;

  _SelectedCourseUnitsPageViewState(this.selectedCourseUnits) : super();

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<CourseUnit>>(
      converter: (store) {
        // TODO get classes from appstate
        return [
          CourseUnit(
              id: 0,
              name: 'Engenharia de Software',
              abbreviation: 'ES',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 2, 4, 'B115', 'ASL', '3LEIC01', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 1, 4, 'B343', 'FFC', '3LEIC02', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 1, 4, 'B206', 'AOR', '3LEIC03', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 2, 4, 'B310', 'ASL', '3LEIC04', 10, 30,
                      12, 30),
                ]),
              ]),
          CourseUnit(
              id: 1,
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
              id: 2,
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
          CourseUnit(id: 3, name: 'Compiladores', abbreviation: 'C', classes: [
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
        ];
      },
      builder: (context, courseUnits) {
        return _SelectedCourseUnitsView(
          selectedCourseUnits: selectedCourseUnits,
          courseUnits: courseUnits,
        );
      },
    );
  }
}

class _SelectedCourseUnitsView extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  const _SelectedCourseUnitsView(
      {this.selectedCourseUnits, this.courseUnits, Key key})
      : super(key: key);

  @override
  _SelectedCourseUnitsViewState createState() =>
      _SelectedCourseUnitsViewState(this.selectedCourseUnits, this.courseUnits);
}

class _SelectedCourseUnitsViewState extends State<_SelectedCourseUnitsView> {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  _SelectedCourseUnitsViewState(this.selectedCourseUnits, this.courseUnits);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PageTitle(name: 'Unidades Curriculares'),
        for (CourseUnit courseUnit in courseUnits)
          CheckboxListTile(
            title: Text(courseUnit.name),
            value: selectedCourseUnits.contains(courseUnit),
            onChanged: (bool value) => setState(() {
              if (value) {
                selectedCourseUnits.select(courseUnit);
              } else {
                selectedCourseUnits.unselect(courseUnit);
              }
            }),
          ),
        Column(
          children: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
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


      ],
    );
  }
}
