import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/course_grade_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  String selectedFilter = 'Current';

  List<CourseUnit> filterCourseUnits(
      String option, List<CourseUnit> courseUnits, String? currYear) {
    switch (option) {
      case 'All':
        return courseUnits;
      case 'Current':
        return courseUnits
            .where((unit) => unit.curricularYear?.toString() == currYear)
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LazyConsumer<ProfileProvider, Profile>(
        builder: (context, profile) {
          final courses = profile.courses;
          final course = courses[0];
          final courseUnits = profile.courseUnits;

          return ListView(
            children: [
              Text(
                course.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              DropdownButton(
                items: ['Current', 'All'].map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                    ),
                  );
                }).toList(),
                value: selectedFilter,
                onChanged: (value) => setState(() {
                  selectedFilter = value!;
                }),
                isExpanded: true,
              ),
              GridView.count(
                crossAxisCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 2,
                children: filterCourseUnits(
                        selectedFilter, courseUnits, course.currYear)
                    .map((unit) {
                  return CourseGradeCard(
                    courseName: unit.abbreviation,
                    ects: unit.ects! as double,
                    grade: unit.grade != null
                        ? double.tryParse(unit.grade!)?.round()
                        : null,
                  );
                }).toList(),
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
