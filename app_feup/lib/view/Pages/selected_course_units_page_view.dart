import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';

class SelectedCourseUnitsPageView extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;

  const SelectedCourseUnitsPageView(
      this.selectedCourseUnits,
      this.courseUnits,
      {Key key})
      : super(key: key);

  @override
  _SelectedCourseUnitsPageViewState createState() =>
      _SelectedCourseUnitsPageViewState(
          this.selectedCourseUnits,
          this.courseUnits
      );
}

class _SelectedCourseUnitsPageViewState extends SecondaryPageViewState {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;
  _SelectedCourseUnitsPageViewState(this.selectedCourseUnits,
      this.courseUnits) : super();

  @override
  Widget getBody(BuildContext context) {
    return _SelectedCourseUnitsView(
      selectedCourseUnits: selectedCourseUnits,
      courseUnits: courseUnits,
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
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
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
                db.insertSelectedCourseUnit(courseUnit);
              } else {
                selectedCourseUnits.unselect(courseUnit);
                db.removeSelectedCourseUnit(courseUnit);
              }
            }),
          ),
        Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('Voltar'),
            ),
          ],
        ),


      ],
    );
  }
}
