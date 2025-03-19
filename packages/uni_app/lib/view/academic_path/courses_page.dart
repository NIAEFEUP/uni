import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/academic_path/widgets/course_units_view.dart';
import 'package:uni/view/academic_path/widgets/no_courses_widget.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/courses/average_bar.dart';
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

  // TODO(Process-ing): Extract this information from API
  // This method is just a band-aid, and will not work correctly for students
  // enrolled in more than one course.
  double _getTotalCredits(Profile profile, Course course) {
    return profile.courseUnits
        .where((courseUnit) => courseUnit.festId == course.festId)
        .map((courseUnit) => (courseUnit.ects ?? 0).toDouble())
        .fold(0, (a, b) => a + b);
  }

  int? _getConclusionYear(Course course) {
    if (course.state == null || course.state == 'A Frequentar') {
      return null;
    }

    final length = course.state!.length;
    final year = int.tryParse(course.state!.substring(length - 5, length - 1));
    return year;
  }

  String _getCourseAbbreviation(Course course) {
    if (course.abbreviation != null) {
      return course.abbreviation!;
    }

    if (course.name == null) {
      return '???';
    }

    return course.name!
        .replaceAll('Licenciatura', 'Licenciatura.')
        .replaceAll('Mestrado', 'Mestrado.')
        .replaceAll('Doutoramento', 'Doutoramento.')
        .replaceAll(RegExp('[^A-Z.]'), '');
  }

  @override
  Widget build(BuildContext context) {
    const bottomNavbarHeight = 120.0;

    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) {
        final courses = profile.courses;
        final course = courses[courseUnitIndex];

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ListView(
            children: [
              Center(
                child: CourseSelection(
                  courseInfos: courses.map((course) {
                    return CourseInfo(
                      abbreviation: _getCourseAbbreviation(course),
                      enrollmentYear: course.firstEnrollment,
                      conclusionYear: _getConclusionYear(course),
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
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 8),
                child: AverageBar(
                  average: (course.currentAverage ?? 0).toDouble(),
                  completedCredits: (course.finishedEcts ?? 0).toDouble(),
                  totalCredits: _getTotalCredits(profile, course),
                  statusText: course.state ?? '',
                  averageText: S.of(context).average,
                ),
              ),
              CourseUnitsView(
                course: course,
              ),
            ],
          ),
        );
      },
      hasContent: (profile) => profile.courses.isNotEmpty,
      onNullContent: LayoutBuilder(
        // Band-aid for allowing refresh on null content
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight, // Height of bottom navbar
            padding: const EdgeInsets.only(bottom: bottomNavbarHeight),
            child: const Center(
              child: NoCoursesWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
