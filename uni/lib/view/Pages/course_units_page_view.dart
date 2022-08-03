import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/course_unit_card.dart';
import 'package:uni/view/Widgets/page_title.dart';

class CourseUnitsPageView extends StatefulWidget {
  const CourseUnitsPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitsPageViewState();
  }
}

class CourseUnitsPageViewState
    extends SecondaryPageViewState<CourseUnitsPageView> {
  List courseUnits = [
    CourseUnit(
        abbreviation: 'FPRO',
        name: 'Fundamentos da Programação',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'MDIS',
        name: 'Matemática Discreta',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'FSC',
        name: 'Fundamentos de Sistemas Computacionais',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'LCOM',
        name: 'Laboratório de Computadores',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'SOPE',
        name: 'Sistemas Operativos',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'LBAW',
        name: 'Laboratório de Bases de Dados e Aplicações Web',
        grade: '20',
        ects: 6),
    CourseUnit(
        abbreviation: 'FSI',
        name: 'Fundamentos de Segurança Informática',
        grade: '20',
        ects: 6),
  ];

  @override
  Widget getBody(BuildContext context) {
    List<Widget> rows = [];
    for (var i = 0; i < courseUnits.length; i += 2) {
      if (i < courseUnits.length - 1) {
        rows.add(IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Flexible(
              child: CourseUnitCard(courseUnits[i].name, courseUnits[i].grade,
                  courseUnits[i].ects)),
          const SizedBox(width: 10),
          Flexible(
              child: CourseUnitCard(courseUnits[i + 1].name,
                  courseUnits[i + 1].grade, courseUnits[i + 1].ects)),
        ])));
      } else {
        rows.add(Row(children: [
          Flexible(
              child: CourseUnitCard(courseUnits[i].name, courseUnits[i].grade,
                  courseUnits[i].ects)),
          const SizedBox(width: 10),
          const Spacer()
        ]));
      }
    }

    return Column(children: <Widget>[
      const PageTitle(name: constants.navCourseUnits),
      Expanded(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: rows,
              )))
    ]);
  }
}
