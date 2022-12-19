import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';

import 'course_unit_sheet_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  final CourseUnitSheet courseUnitSheet;
  final String courseUnitName;

  const CourseUnitSheetView(this.courseUnitName, this.courseUnitSheet,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: [
              _courseObjectiveWidget(),
              _courseProgramWidget(),
              //_courseEvaluationWidget(iconColor),
              //_courseTeachersWidget(iconColor)
            ])) //ListView(children: sections)),
        );
  }

  Widget _courseObjectiveWidget() {
    return CourseUnitSheetCard(
        'Objetivos', Text(courseUnitSheet.sections['goals']!));
  }

  Widget _courseProgramWidget() {
    return CourseUnitSheetCard(
      'Programa',
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            courseUnitSheet.sections['program']!,
            key: Key('$courseUnitName - Programa Text'),
            style: const TextStyle(fontWeight: FontWeight.w400),
          )),
    );
  }

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
}
