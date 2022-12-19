import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';

class CourseUnitSheetView extends StatelessWidget {
  final double padding = 12.0;
  final CourseUnitSheet courseUnitSheet;
  final String courseUnitName;

  const CourseUnitSheetView(this.courseUnitName, this.courseUnitSheet,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).primaryColor;
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: [
              _courseObjectiveWidget(iconColor),
              _courseProgramWidget(iconColor),
              //_courseEvaluationWidget(iconColor),
              //_courseTeachersWidget(iconColor)
            ])) //ListView(children: sections)),
        );
  }

  // Widget _courseTeachersWidget(Color iconColor) {
  //   return ExpansionTile(
  //       iconColor: iconColor,
  //       key: Key('$courseUnitName - Docencia'),
  //       title: _sectionTitle('Docência'),
  //       tilePadding: const EdgeInsets.only(right: 20),
  //       children: [
  //         Column(
  //             key: Key('$courseUnitName - Docencia Tables'),
  //             children: getTeachers(courseUnitSheet.getTeachers()))
  //       ]);
  // }
  //
  // List<Widget> getTeachers(Map<String, List<CourseUnitTeacher>> teachers) {
  //   final List<Widget> widgets = [];
  //   for (String type in teachers.keys) {
  //     widgets.add(_subSectionTitle(type));
  //     widgets.add(Table(
  //         columnWidths: const {1: FractionColumnWidth(.2)},
  //         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //         children: getTeachersTable(teachers[type])));
  //     widgets.add(const Padding(
  //       padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
  //     ));
  //   }
  //   widgets.removeLast();
  //   return widgets;
  // }

  /*List<TableRow> getTeachersTable(List<CourseUnitTeacher> teachers) {
    final List<TableRow> teachersTableLines = [];
    for (CourseUnitTeacher teacher in teachers) {
      teachersTableLines.add(TableRow(children: [
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 5.0),
          child: Text(
            teacher.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 8.0, right: 5.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(teacher.hours, style: const TextStyle(fontSize: 14))),
        )
      ]));
    }
    return [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 5.0),
              child: const Text(
                'Docente',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0, right: 5.0),
              child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Horas',
                    style: TextStyle(fontSize: 14),
                  )),
            )
          ])
        ] +
        teachersTableLines;
  }*/

  Widget _courseObjectiveWidget(Color iconColor) {
    return ExpansionTile(
        iconColor: iconColor,
        title: _sectionTitle('Objetivos'),
        key: Key(courseUnitName + ' - Objetivos'),
        tilePadding: const EdgeInsets.only(right: 20),
        children: [
          Container(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  courseUnitSheet.sections['goals']!,
                  key: Key(courseUnitName + ' - Objetivos Text'),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                )),
          ),
        ]);
  }

  Widget _courseProgramWidget(Color iconColor) {
    return ExpansionTile(
        iconColor: iconColor,
        title: _sectionTitle('Programa'),
        key: Key('$courseUnitName - Programa'),
        tilePadding: const EdgeInsets.only(right: 20),
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                courseUnitSheet.sections['program']!,
                key: Key('$courseUnitName - Programa Text'),
                style: const TextStyle(fontWeight: FontWeight.w400),
              )),
        ]);
  }

/*  Widget _courseEvaluationWidget(Color iconColor) {
    return ExpansionTile(
        iconColor: iconColor,
        title: _sectionTitle('Avaliação'),
        key: Key(courseUnitName + ' - Avaliacao'),
        tilePadding: const EdgeInsets.only(right: 20),
        children: [
          Column(children: [
            Table(
                key: Key(courseUnitName + ' - Avaliacao Table'),
                columnWidths: const {1: FractionColumnWidth(.3)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: getEvaluationTable()),
          ])
        ]);
  }*/

  /*List<TableRow> getEvaluationTable() {
    final List<TableRow> evaluationTableLines = [];
    for (CourseUnitEvaluationComponent component
        in courseUnitSheet.evaluationComponents) {
      evaluationTableLines.add(TableRow(children: [
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 5.0),
          child: Text(
            component.designation,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 8.0, right: 5.0),
          child: Align(
              alignment: Alignment.centerRight,
              child:
                  Text(component.weight, style: const TextStyle(fontSize: 14))),
        )
      ]));
    }
    return [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 5.0),
              child: const Text(
                'Designação',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0, right: 5.0),
              child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Peso (%)',
                    style: TextStyle(fontSize: 14),
                  )),
            )
          ])
        ] +
        evaluationTableLines;
  }*/

  Widget _sectionTitle(String title) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Color.fromRGBO(50, 50, 50, 100),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ));
  }

  Widget _subSectionTitle(String title) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Color.fromRGBO(50, 50, 50, 100),
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
        ));
  }
}
