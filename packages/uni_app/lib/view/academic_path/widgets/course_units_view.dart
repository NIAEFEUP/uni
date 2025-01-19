import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/course_grade_card.dart';
import 'package:uni_ui/icons.dart';

class CourseUnitsView extends StatefulWidget {
  const CourseUnitsView({super.key});

  @override
  State<CourseUnitsView> createState() => _CourseUnitsViewState();
}

class _CourseUnitsViewState extends State<CourseUnitsView> {
  bool isGrid = true;
  String? selectedSchoolYear = PreferencesController.getSchoolYearValue();
  String? selectedSemester = PreferencesController.getSemesterValue();

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) {
        final courseUnits = profile.courseUnits;
        final courseGradeCards =
            _applyFilters(courseUnits, selectedSchoolYear, selectedSemester)
                .map(_toCourseGradeCard)
                .toList();

        return Column(
          children: [
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
              children: courseGradeCards,
            ),
          ],
        );
      },
      hasContent: (profile) => true,
      onNullContent: Container(),
    );
  }

  CourseGradeCard _toCourseGradeCard(CourseUnit unit) {
    return CourseGradeCard(
      courseName: unit.name,
      ects: unit.ects! as double,
      grade: unit.grade != null ? double.tryParse(unit.grade!)?.round() : null,
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
