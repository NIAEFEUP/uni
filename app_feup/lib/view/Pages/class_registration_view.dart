import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/class_registration_model.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
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
        semesterCode: Semester.second.toCode(),
        semesterName: Semester.second.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 2, 4, 'B115', 'ASL', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 1, 4, 'B343', 'FFC', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 1, 4, 'B206', 'AOR', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 2, 4, 'B310', 'ASL', '3LEIC04', 10, 30, 12, 30),
          ]),
        ]),
    CourseUnit(
        id: 1,
        name: 'Inteligência Artificial',
        abbreviation: 'IA',
        semesterCode: Semester.second.toCode(),
        semesterName: Semester.second.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 2, 4, 'B342', 'HCL', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 2, 4, 'B217', 'APR', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture(
                'IA', 'TP', 1, 4, 'B206', 'NRSG', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 1, 4, 'B202', 'NRSG', '3LEIC04', 8, 30, 10, 30),
          ]),
        ]),
    CourseUnit(
        id: 2,
        name: 'Computação Paralela e Distribuída',
        abbreviation: 'CPD',
        semesterCode: Semester.second.toCode(),
        semesterName: Semester.second.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B342', 'PFS+JGB', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B343', 'SCS1', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 2, 4, 'B205', 'PMAADO', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B202', 'AJMC', '3LEIC04', 10, 30, 12, 30),
          ]),
        ]),
    CourseUnit(
        id: 3,
        name: 'Compiladores',
        abbreviation: 'C',
        semesterCode: Semester.second.toCode(),
        semesterName: Semester.second.toName(),
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
            Lecture('C', 'TP', 2, 4, 'B217', 'LGBC', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture('C', 'TP', 2, 4, 'B205', 'PMSP', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture('C', 'TP', 2, 4, 'B310', 'PMSP', '3LEIC04', 8, 30, 10, 30),
          ]),
        ]),
    CourseUnit(
        id: 4,
        name: 'Fundamentos de Segurança Informática',
        abbreviation: 'FSI',
        semesterCode: Semester.first.toCode(),
        semesterName: Semester.first.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 4, 4, 'B115', 'MMC', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture(
                'FSI', 'TP', 1, 4, 'B110', 'APM', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 2, 4, 'B115', 'RSM', '3LEIC03', 11, 0, 13, 0),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 2, 4, 'B217', 'MMC', '3LEIC04', 11, 0, 13, 0),
          ]),
        ]),
    CourseUnit(
        id: 5,
        name: 'Laboratório de Bases de Dados e Aplicações Web',
        abbreviation: 'LBAW',
        semesterCode: Semester.first.toCode(),
        semesterName: Semester.first.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 1, 4, 'B308', 'tbs', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 2, 4, 'B305', 'SSN', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 1, 4, 'B302', 'tbs', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 4, 4, 'B305', 'PMAB', '3LEIC04', 10, 30, 12, 30),
          ]),
        ]),
    CourseUnit(
        id: 6,
        name: 'Linguagens e Tecnologias Web',
        abbreviation: 'LTW',
        semesterCode: Semester.first.toCode(),
        semesterName: Semester.first.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 4, 4, 'B308', 'JPD', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 1, 4, 'B308', 'TNMFLD', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 1, 4, 'B102', 'JNVMS', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture('LTW', 'TP', 4, 4, 'B305', 'MFF', '3LEIC04', 8, 30, 10, 30),
          ]),
        ]),
    CourseUnit(
        id: 7,
        name: 'Programação Funcional e em Lógica',
        abbreviation: 'PFL',
        semesterCode: Semester.first.toCode(),
        semesterName: Semester.first.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 2, 4, 'B313', 'DCS', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 4, 4, 'B203', 'JPSFF', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 4, 4, 'B107', 'JPSFF', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 1, 4, 'B101', 'GMLTL', '3LEIC04', 10, 30, 12, 30),
          ]),
        ]),
    CourseUnit(
        id: 8,
        name: 'Redes de Computadores',
        abbreviation: 'RC',
        semesterCode: Semester.first.toCode(),
        semesterName: Semester.first.toName(),
        classes: [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 1, 4, 'I320+I321', 'RLC', '3LEIC01', 16, 0, 18, 0),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture('RC', 'TP', 2, 4, 'I320+I321', 'SALC', '3LEIC02', 8, 30, 10,
                30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 4, 4, 'I320+I321', 'FBT', '3LEIC03', 14, 0, 16, 0),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 4, 4, 'I320+I321', 'FBT', '3LEIC04', 16, 0, 18, 0),
          ]),
        ]),
  ];

  Map<Semester, SchedulePreferenceList> options = Map();
  Map<Semester, CourseUnitsForClassRegistration> selectedCourseUnits = Map();
  Semester _semester = Semester.second;
  Future<void> ongoingFuture = null;

  Future<void> startGetData(Semester semester) async {
    final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
    if (!options.containsKey(semester)) {
      options[semester] = SchedulePreferenceList(
        semester,
        await db.getScheduleOptions(semester),
      );
    }
    if (!selectedCourseUnits.containsKey(semester)) {
      selectedCourseUnits[semester] = CourseUnitsForClassRegistration(
        await db.getSelectedCourseUnits(semester),
        courseUnits
            .where((element) =>
                SemesterUtils.fromCode(element.semesterCode) == semester)
            .toList(),
      );
    }
  }

  Future<void> getOngoingOrStart(Semester semester) {
    if (ongoingFuture == null) {
      ongoingFuture = startGetData(semester);
    }

    return ongoingFuture;
  }

  bool isDataReady() {
    return options.containsKey(_semester) &&
        selectedCourseUnits.containsKey(_semester);
  }

  @override
  Widget getBody(BuildContext context) {
    return FutureBuilder<void>(
      future: getOngoingOrStart(_semester),
      builder: (BuildContext innerContext, AsyncSnapshot<void> snapshot) {
        if (isDataReady()) {
          return _ClassRegistrationView(
            semester: _semester,
            schedulePreferences: options[_semester],
            selectedCourseUnits: selectedCourseUnits[_semester],
            courseUnits: courseUnits
                .where((element) =>
                    SemesterUtils.fromCode(element.semesterCode) == _semester)
                .toList(),
            onChangeSemester: (Semester semester) {
              setState(() {
                _semester = semester;
                ongoingFuture = null;
              });
            },
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
      },
    );
  }
}

class _ClassRegistrationView extends StatefulWidget {
  final SchedulePreferenceList schedulePreferences;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;
  final void Function(Semester) onChangeSemester;
  final Semester semester;

  const _ClassRegistrationView(
      {this.semester,
      this.schedulePreferences,
      this.selectedCourseUnits,
      this.courseUnits,
      this.onChangeSemester,
      Key key})
      : super(key: key);

  @override
  _ClassRegistrationViewState createState() => _ClassRegistrationViewState(
        this.semester,
        this.schedulePreferences,
        this.selectedCourseUnits,
        this.courseUnits,
        this.onChangeSemester,
      );
}

class _ClassRegistrationViewState extends State<_ClassRegistrationView> {
  final SchedulePreferenceList schedulePreferences;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final List<CourseUnit> courseUnits;
  final void Function(Semester) onChangeSemester;
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  final Semester _semester;

  _ClassRegistrationViewState(this._semester, this.schedulePreferences,
      this.selectedCourseUnits, this.courseUnits, this.onChangeSemester);

  List<Widget> buildSemesterRadio(Semester semester) {
    return [
      SizedBox(width: 5),
      Radio<Semester>(
        value: semester,
        groupValue: _semester,
        onChanged: onChangeSemester,
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            onChangeSemester(semester);
          });
        },
        child: Text(semester.toName()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      Row(
        children:
            Semester.values.map(buildSemesterRadio).fold([], (p, e) => p + e),
      ),
      SelectedCoursesCard(
        selectedCourseUnits: selectedCourseUnits,
        courseUnits: courseUnits,
        onUpdateList: () => setState(() => {}),
      ),
      if (this.selectedCourseUnits.isNotEmpty)
        SchedulePlannerCard(
          items: schedulePreferences,
          selectedCourseUnits: selectedCourseUnits,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              schedulePreferences.reorder(oldIndex, newIndex);
            });
            db.reorderOptions(schedulePreferences.preferences);
          },
        ),
    ]);
  }
}
