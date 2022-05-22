
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/view/Pages/class_registration_view.dart';
import 'package:uni/view/Pages/selected_course_units_page_view.dart';
import 'package:uni/view/Widgets/page_transition.dart';

import 'generic_card.dart';

class SelectedCoursesCard extends GenericCard {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  SelectedCoursesCard({
    this.selectedCourseUnits,
    this.courseUnits,
    Key key}) : super(key: key);


  @override
  Widget buildCardContent(BuildContext context) {
    final List<String> courseUnitsAbbreviated =
    selectedCourseUnits.selected
        ?.map((courseUnit) => courseUnit.abbreviation)
        ?.toList();

    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.passthrough,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.edit_outlined),
        ),
        Column(
          children: selectedCourseUnits.selected.isEmpty
              ? [
                  Text('Nenhuma unidade curricular'),
                  Text('selecionada'),
                  SizedBox(height: 10)
                ]
              : [
                  Text('Unidades curriculares selecionadas:'),
                  Text(
                    courseUnitsAbbreviated.join(', '),
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(color: Theme.of(context).accentColor),
                  ),
                  SizedBox(height: 10)
                ],
        ),
      ],
    );
  }

  @override
  String getTitle() => null;

  @override
  onClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedCourseUnitsPageView(
            selectedCourseUnits,
            courseUnits
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      Navigator.push(context, PageTransition.makePageTransition(
          page: ClassRegistrationPageView()));
    });
  }
}
