import 'package:flutter/material.dart';
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

class _FilterOption {
  const _FilterOption({
    required this.name,
    required this.value,
    required this.filter,
  });

  final String name;
  final int value;
  final List<CourseUnit> Function(
    List<CourseUnit> courseUnits,
    String? currYear,
  ) filter;

  DropdownMenuItem<int> toDropdownMenuItem() {
    return DropdownMenuItem(
      value: value,
      child: Text(name),
    );
  }
}

class CoursesPageState extends State<CoursesPage> {
  int selectedFilter = 0;
  bool isGrid = true;
  int courseUnitIndex = 0;

  void _onCourseUnitSelected(int index) {
    setState(() {
      courseUnitIndex = index;
    });
  }

  CourseGradeCard _toCourseGradeCard(CourseUnit unit) {
    return CourseGradeCard(
      courseName: unit.abbreviation,
      ects: unit.ects! as double,
      grade: unit.grade != null ? double.tryParse(unit.grade!)?.round() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = [
      _FilterOption(
        name: S.of(context).attending,
        value: 0,
        filter: (courseUnits, currYear) {
          return courseUnits
              .where((unit) => unit.curricularYear.toString() == currYear)
              .toList();
        },
      ),
      _FilterOption(
        name: S.of(context).all_feminine,
        value: 1,
        filter: (courseUnits, currYear) {
          return courseUnits;
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LazyConsumer<ProfileProvider, Profile>(
        builder: (context, profile) {
          final courses = profile.courses;
          final course = courses[courseUnitIndex];
          final courseUnitCards = filterOptions[selectedFilter]
              .filter(profile.courseUnits, course.currYear)
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
                  DropdownButton(
                    items: filterOptions
                        .map<DropdownMenuItem<int>>(
                          (option) => option.toDropdownMenuItem(),
                        )
                        .toList(),
                    value: selectedFilter,
                    onChanged: (value) => setState(() {
                      selectedFilter = value!;
                    }),
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
}
