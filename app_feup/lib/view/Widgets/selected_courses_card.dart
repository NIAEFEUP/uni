import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:uni/view/Pages/class_registration_schedule_editor_view.dart';

import 'generic_card.dart';

class SelectedCoursesCard extends GenericCard {
  final CourseUnitsForClassRegistration selectedCourseUnits;

  SelectedCoursesCard({this.selectedCourseUnits, Key key}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    final List<String> courseUnitsAbbreviated = selectedCourseUnits.selected
        .map((courseUnit) => courseUnit.abbreviation)
        .toList();

    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.passthrough,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.edit_outlined),
        ),
        Column(
          children: [
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
  onClick(BuildContext context) => {
        // TODO open the select courses page
      };
}
