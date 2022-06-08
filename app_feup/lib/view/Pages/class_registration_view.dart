import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/class_fetcher/class_fetcher.dart';
import 'package:uni/controller/class_fetcher/class_fetcher_mock.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/registerables_fetcher/registerables_fetcher.dart';
import 'package:uni/controller/registerables_fetcher/registerables_fetcher_mock.dart';
import 'package:uni/model/class_registration_model.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
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
  List<CourseUnit> courseUnits = [];

  Map<Semester, SchedulePreferenceList> options = Map();
  Map<Semester, CourseUnitsForClassRegistration> selectedCourseUnits = Map();
  Semester _semester = null;
  Future<void> ongoingFuture = null;
  SharedPreferences prefs = null;
  Future<void> startGetData(Semester semester) async {
    final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();

    if (semester == null) {
      prefs = await SharedPreferences.getInstance();
      _semester = (prefs.getInt('semester') ?? 1) == 1
          ? Semester.first
          : Semester.second;
      semester = _semester;
    }

    if (!options.containsKey(semester)) {
      options[semester] = SchedulePreferenceList(
        semester,
        await db.getScheduleOptions(semester),
      );
    }

    final RegisterablesFetcher regFetcher = RegisterablesFetcherMock();
    courseUnits = await regFetcher.getRegisterables();

    final ClassFetcher classFetcher = ClassFetcherMock();
    courseUnits.forEach((unit) async {
      final List<CourseUnitClass> classes =
          await classFetcher.getClasses(unit.occurrId);
      unit.classes = classes;
    });

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

  Future<void> getOngoingOrStart(Semester semester) async {
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
                prefs.setInt('semester', _semester.toInt());
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
          onUpdateList: () => onChangeSemester(_semester),
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
