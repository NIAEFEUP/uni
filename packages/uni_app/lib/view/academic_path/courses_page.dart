import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/view/academic_path/widgets/course_units_view.dart';
import 'package:uni/view/academic_path/widgets/no_courses_widget.dart';
import 'package:uni_ui/courses/average_bar.dart';
import 'package:uni_ui/courses/course_info.dart';
import 'package:uni_ui/courses/course_selection.dart';

class CoursesPage extends ConsumerStatefulWidget {
  const CoursesPage({super.key});

  @override
  ConsumerState<CoursesPage> createState() => CoursesPageState();
}

class CoursesPageState extends ConsumerState<CoursesPage> {
  var _courseUnitIndex = 0;

  void _onCourseUnitSelected(int index) {
    setState(() {
      _courseUnitIndex = index;
    });
  }

  // TODO(Process-ing): Extract this information from API
  // This method is just a band-aid, and will not work correctly for students
  // enrolled in more than one course.
  double _getTotalCredits(Profile profile, Course course) {
    final Map<String, double> uniqueCourseUnitsEcts = {};

    for (final cu in profile.courseUnits) {
      if (cu.festId != course.festId) {
        continue;
      }

      final gradeStr = cu.grade?.trim();
      final grade = double.tryParse(gradeStr ?? '');

      final bool isPassed = grade != null && grade >= 10;
      final bool isCurrentlyAttempting = gradeStr == null || gradeStr.isEmpty;

      if (isPassed || isCurrentlyAttempting) {
        if (!uniqueCourseUnitsEcts.containsKey(cu.name)) {
          uniqueCourseUnitsEcts[cu.name] = cu.ects ?? 0;
        }
      }
    }

    return uniqueCourseUnitsEcts.values.fold(0, (a, b) => a + b);
  }

  int? _getEnrollmentYear(Course course) {
    if (course.state == null) {
      return null;
    }

    if (course.state != 'A Frequentar' &&
        !(course.state?.startsWith('Concluído') ?? false)) {
      return null;
    }

    if (course.firstEnrollment == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month - 8, now.day).year;
    }

    return course.firstEnrollment!;
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
    return DefaultConsumer<Profile>(
      provider: profileProvider,
      builder: (context, ref, profile) {
        final courses = profile.courses;
        final course = courses[_courseUnitIndex];

        return ListView(
          padding: const EdgeInsets.only(
            bottom: 10,
            top: 10,
            left: 20,
            right: 20,
          ),
          children: [
            Center(
              child: CourseSelection(
                courseInfos:
                    courses.map((course) {
                      return CourseInfo(
                        abbreviation: _getCourseAbbreviation(course),
                        enrollmentYear: _getEnrollmentYear(course),
                        conclusionYear: _getConclusionYear(course),
                      );
                    }).toList(),
                onSelected: _onCourseUnitSelected,
                selected: _courseUnitIndex,
                nowText: S.of(context).now,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                course.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 8),
              child: AverageBar(
                average: course.currentAverage ?? 0,
                completedCredits: course.finishedEcts ?? 0,
                totalCredits: _getTotalCredits(profile, course),
                statusText: course.state ?? '',
                averageText: S.of(context).average,
              ),
            ),
            CourseUnitsView(course: course),
          ],
        );
      },
      nullContentWidget: LayoutBuilder(
        // Band-aid for allowing refresh on null content
        builder:
            (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: constraints.maxHeight,
                padding: const EdgeInsets.only(bottom: 120),
                child: const Center(child: NoCoursesWidget()),
              ),
            ),
      ),
      hasContent: (profile) => profile.courses.isNotEmpty,
    );
  }
}
