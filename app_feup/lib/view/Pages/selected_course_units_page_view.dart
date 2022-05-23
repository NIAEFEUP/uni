import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';

class SelectedCourseUnitsPageView extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  const SelectedCourseUnitsPageView(
      this.selectedCourseUnits, this.courseUnits, {Key key})
      : super(key: key);

  @override
  _SelectedCourseUnitsPageViewState createState() =>
      _SelectedCourseUnitsPageViewState(
          this.selectedCourseUnits, this.courseUnits);
}

class _SelectedCourseUnitsPageViewState extends UnnamedPageView {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  _SelectedCourseUnitsPageViewState(this.selectedCourseUnits, this.courseUnits);

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        PageTitle(name: 'Unidades Curriculares'),
        for (CourseUnit courseUnit in courseUnits)
          CheckboxListTile(
            title: Text(courseUnit.name),
            value: selectedCourseUnits.contains(courseUnit),
            onChanged: (bool value) {
              if (value) {
                setState(() {
                  selectedCourseUnits.select(courseUnit);
                });
                db.insertSelectedCourseUnit(courseUnit);
              } else {
                setState(() {
                  selectedCourseUnits.unselect(courseUnit);
                });
                db.removeSelectedCourseUnit(courseUnit);
              }
            },
          ),
      ],
    );
  }
}
