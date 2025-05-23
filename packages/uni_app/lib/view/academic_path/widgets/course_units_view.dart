import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/course_grade_card.dart';
import 'package:uni_ui/icons.dart';

class CourseUnitsView extends StatefulWidget {
  const CourseUnitsView({super.key, this.course});

  final Course? course;

  @override
  State<CourseUnitsView> createState() => _CourseUnitsViewState();
}

class _CourseUnitsViewState extends State<CourseUnitsView> {
  bool isGrid = PreferencesController.getServiceCardsIsGrid();
  String? selectedSchoolYear = PreferencesController.getSchoolYearValue();
  String? selectedSemester = PreferencesController.getSemesterValue();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) {
        final courseUnits = profile.courseUnits;
        final courseGradeCards =
            _applyFilters(courseUnits)
                .map((courseUnit) => _toCourseGradeCard(courseUnit, context))
                .toList();

        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: DropdownButton(
                    underline: Container(),
                    items:
                        _getAvailableYears(courseUnits)
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
                  underline: Container(),
                  items:
                      _getAvailableSemesters(courseUnits)
                          .map(
                            (semester) =>
                                _toDropdownMenuItem(semester, '1S+2S'),
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
                      PreferencesController.setServiceCardsIsGrid(false);
                    });
                  },
                ),
                IconButton(
                  icon: const UniIcon(UniIcons.grid),
                  onPressed: () {
                    setState(() {
                      isGrid = true;
                      PreferencesController.setServiceCardsIsGrid(true);
                    });
                  },
                ),
              ],
            ),
            GridView.count(
              crossAxisCount: isGrid ? 2 : 1,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio:
                  isGrid
                      ? (width - 40) / (width * 2) * 5
                      : (width - 32) / width * 5,
              // Calculate aspect ratio, to avoid inconsistencies between grid and list view
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: courseGradeCards,
            ),
          ],
        );
      },
      hasContent: (profile) => true,
      onNullContent: Container(),
    );
  }

  void _toCourseGradeCardOnTap(CourseUnit courseUnit, BuildContext context) {
    Navigator.pushNamed(
      context,
      '/${NavigationItem.navCourseUnit.route}',
      arguments: courseUnit,
    );
  }

  CourseGradeCard _toCourseGradeCard(CourseUnit unit, BuildContext context) {
    return CourseGradeCard(
      courseName: unit.name,
      ects: (unit.ects ?? 0).toDouble(),
      grade: unit.grade != null ? double.tryParse(unit.grade!)?.round() : null,
      tooltip: unit.name,
      onTap: () => _toCourseGradeCardOnTap(unit, context),
    );
  }

  static List<String?> _getAvailableYears(List<CourseUnit> courseUnits) {
    final years = courseUnits.map((unit) => unit.schoolYear).nonNulls.toSet();
    final yearsList =
        years.map((year) => year as String?).toList()
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
    return DropdownMenuItem(value: option, child: Text(option ?? nullName));
  }

  static bool compareToFilter<T>(T? value, T? filter) {
    return filter == null || value == filter;
  }

  List<CourseUnit> _applyFilters(List<CourseUnit> courseUnits) {
    return courseUnits
        .where(
          (unit) =>
              compareToFilter(unit.festId, widget.course?.festId) &&
              compareToFilter(unit.schoolYear, selectedSchoolYear) &&
              compareToFilter(unit.semesterCode, selectedSemester),
        )
        .toList();
  }
}
