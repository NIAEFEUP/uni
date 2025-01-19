import 'package:flutter/material.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/academic_path/widgets/course_units_view.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/courses/course_info.dart';
import 'package:uni_ui/courses/course_selection.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  int courseUnitIndex = 0;

  void _onCourseUnitSelected(int index) {
    setState(() {
      courseUnitIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LazyConsumer<ProfileProvider, Profile>(
        builder: (context, profile) {
          final courses = profile.courses;
          final course = courses[courseUnitIndex];

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
              const CourseUnitsView(),
            ],
          );
        },
        hasContent: (profile) => profile.courses.isNotEmpty,
        onNullContent: Container(),
      ),
    );
  }
}
