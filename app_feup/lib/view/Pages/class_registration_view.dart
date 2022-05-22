import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/schedule_planner_card.dart';
import 'package:uni/view/Widgets/selected_courses_card.dart';

class ClassRegistrationPageView extends StatefulWidget {
  const ClassRegistrationPageView({Key key}) : super(key: key);

  @override
  _ClassRegistrationPageViewState createState() =>
      _ClassRegistrationPageViewState();
}

class _ClassRegistrationPageViewState extends SecondaryPageViewState {
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  Future<List<ScheduleOption>> options;

  @override
  void initState() {
    super.initState();
    options = db.getScheduleOptions();
  }

  @override
  Widget getBody(BuildContext context) {

    CourseUnit courseUnitMock = CourseUnit(
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
        ]);

    return FutureBuilder<List<ScheduleOption>>(
        future: this.options,
        builder: (
            BuildContext innerContext,
            AsyncSnapshot<List<ScheduleOption>> snapshot) {
          if (snapshot.hasData) {
                return _ClassRegistrationView(
                    schedulePreferences: SchedulePreferenceList(
                        preferences: snapshot.data
                    ),
                    selectedCourseUnits: CourseUnitsForClassRegistration(
                        selected: [courseUnitMock]
                    ),
                );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          );
        });
  }
}

class _ClassRegistrationView extends StatefulWidget {
  final SchedulePreferenceList schedulePreferences;
  final CourseUnitsForClassRegistration selectedCourseUnits;

  const _ClassRegistrationView(
      {this.schedulePreferences, this.selectedCourseUnits, Key key})
      : super(key: key);

  @override
  _ClassRegistrationViewState createState() => _ClassRegistrationViewState(
      this.schedulePreferences, this.selectedCourseUnits);
}

class _ClassRegistrationViewState extends State<_ClassRegistrationView> {
  final SchedulePreferenceList schedulePreferences;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();

  _ClassRegistrationViewState(
      this.schedulePreferences, this.selectedCourseUnits);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      SelectedCoursesCard(
        selectedCourseUnits: selectedCourseUnits,
      ),
      SchedulePlannerCard(
          items: schedulePreferences,
          selectedCourseUnits: selectedCourseUnits,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              schedulePreferences.reorder(oldIndex, newIndex);
              db.reorderOptions(schedulePreferences.preferences);
            });
          }),
    ]);
  }
}
