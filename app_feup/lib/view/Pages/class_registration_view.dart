import 'package:tuple/tuple.dart';
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

  final List<CourseUnit> courseUnits = [
    CourseUnit(
        id: 0,
        name: 'Engenharia de Software',
        abbreviation: 'ES',
        semester: 2,
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
        semester: 2,
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
        semester: 2,
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
    CourseUnit(
        id: 3,
        name: 'Compiladores',
        abbreviation: 'C',
        semester: 1,
        classes: [
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

  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  Future<List<ScheduleOption>> options;
  Future<List<String>> courseUnitAbbreviations;

  @override
  void initState() {
    super.initState();
    options = db.getScheduleOptions();
    courseUnitAbbreviations = db.getSelectedCourseUnits(2);
  }

  Future<Tuple2<List<ScheduleOption>, List<String>>> getFutures() async{
    final options = await this.options;
    final abrvs = await this.courseUnitAbbreviations;
    return Tuple2(options, abrvs);
  }

  @override
  Widget getBody(BuildContext context) {

    return FutureBuilder<Tuple2<List<ScheduleOption>, List<String>>>(
        future: getFutures(),
        builder: (
            BuildContext innerContext,
            AsyncSnapshot<Tuple2<List<ScheduleOption>, List<String>>>
            snapshot) {
          if (snapshot.hasData) {

                return _ClassRegistrationView(
                    schedulePreferences: SchedulePreferenceList(
                        preferences: snapshot.data.item1
                    ),
                    selectedCourseUnits: CourseUnitsForClassRegistration(
                        snapshot.data.item2, courseUnits
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
        courseUnits: selectedCourseUnits.allCourseUnits,
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
