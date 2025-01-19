import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/course_grade_card.dart';
import 'package:uni_ui/courses/course_info.dart';
import 'package:uni_ui/courses/course_selection.dart';
import 'package:uni_ui/icons.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  bool isGrid = true;
  int courseUnitIndex = 0;
  String? selectedSchoolYear = PreferencesController.getSchoolYearValue();
  String? selectedSemester = PreferencesController.getSemesterValue();

  void _onCourseUnitSelected(int index) {
    setState(() {
      courseUnitIndex = index;
    });
  }

  CourseGradeCard _toCourseGradeCard(CourseUnit unit) {
    return CourseGradeCard(
      courseName: unit.name,
      ects: unit.ects! as double,
      grade: unit.grade != null ? double.tryParse(unit.grade!)?.round() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LazyConsumer<ProfileProvider, Profile>(
        builder: (context, profile) {
          final courses = profile.courses;
          final course = courses[courseUnitIndex];

          final courseUnits = profile.courseUnits;
          final courseUnitCards =
              _applyFilters(courseUnits, selectedSchoolYear, selectedSemester)
                  .map(_toCourseGradeCard)
                  .toList();

          return ListView(
            children: [
              Center(
                child: CourseSelection(
                  courseInfos: courses.map((course) {
                    return CourseInfo(
                      abbreviation: course.abbreviation ?? '???',
                    );
                  }).toList(),
                  onSelected: _onCourseUnitSelected,
                  selected: courseUnitIndex,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  course.name ?? '',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DropdownButton(
                      items: _getAvailableYears(courseUnits)
                          .map(
                            (year) => _toDropdownMenuItem(
                              year,
                              S.of(context).all_feminine,
                            ),
                          )
                          .toList(),
                      value: selectedSchoolYear,
                      onChanged: (value) {
                        setState(() {
                          selectedSchoolYear = value;
                        });
                        PreferencesController.setSchoolYearValue(value);
                      },
                    ),
                  ),
                  DropdownButton(
                    items: _getAvailableSemesters(courseUnits)
                        .map(
                          (semester) => _toDropdownMenuItem(
                            semester,
                            '1S+2S',
                          ),
                        )
                        .toList(),
                    value: selectedSemester,
                    onChanged: (value) {
                      setState(() {
                        selectedSemester = value;
                      });
                      PreferencesController.setSemesterValue(value);
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const UniIcon(UniIcons.list),
                    onPressed: () {
                      setState(() {
                        isGrid = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: const UniIcon(UniIcons.grid),
                    onPressed: () {
                      setState(() {
                        isGrid = true;
                      });
                    },
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: isGrid ? 2 : 1,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: isGrid ? 2.5 : 5,
                children: courseUnitCards,
              ),
            ],
          );
        },
        hasContent: (profile) => profile.courses.isNotEmpty,
        onNullContent: Container(),
      ),
    );
  }

  static List<String?> _getAvailableYears(List<CourseUnit> courseUnits) {
    final years = courseUnits.map((unit) => unit.schoolYear).nonNulls.toSet();
    final yearsList = years.map((year) => year as String?).toList()
      ..sort()
      ..insert(0, null);
    return yearsList;
  }

  static List<String?> _getAvailableSemesters(List<CourseUnit> courseUnits) {
    final semesters =
        courseUnits.map((unit) => unit.semesterCode).nonNulls.toSet();
    final semestersList =
        semesters.map((semester) => semester as String?).toList()
          ..sort()
          ..insert(0, null);
    return semestersList;
  }

  static DropdownMenuItem<String> _toDropdownMenuItem(
    String? option,
    String nullName,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Text(option ?? nullName),
    );
  }

  static bool compareToFilter(String? value, String? filter) {
    return filter == null || value == filter;
  }

  static List<CourseUnit> _applyFilters(
    List<CourseUnit> courseUnits,
    String? year,
    String? semester,
  ) {
    return courseUnits
        .where(
          (unit) =>
              compareToFilter(unit.schoolYear, year) &&
              compareToFilter(unit.semesterCode, semester),
        )
        .toList();
  }
}
