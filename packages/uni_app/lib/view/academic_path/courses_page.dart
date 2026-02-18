import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/view/academic_path/widgets/course_units_view.dart';
import 'package:uni/view/academic_path/widgets/courses_page_shimmer.dart';
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
  static Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_lastLocale != locale) {
      _lastLocale = locale;
      Future.microtask(() {
        ref.read(profileProvider.notifier).refreshRemote();
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  var _courseUnitIndex = 0;
  var _blurSensitiveInfo = PreferencesController.getHideSensitiveInfoToggle();

  void _toggleBlur() {
    setState(() {
      _blurSensitiveInfo = !_blurSensitiveInfo;
    });
  }

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

    final state = course.state!;
    final bool isAttending =
        state.toLowerCase().contains('frequent') ||
        state.toLowerCase().contains('attend');
    final bool isConcluded = state.toLowerCase().contains('concl');

    if (!isAttending && !isConcluded) {
      return null;
    }

    if (course.firstEnrollment == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month - 8, now.day).year;
    }

    return course.firstEnrollment!;
  }

  int? _getConclusionYear(Course course) {
    if (course.state == null) {
      return null;
    }

    final state = course.state!;
    if (state.toLowerCase().contains('frequent') ||
        state.toLowerCase().contains('attend')) {
      return null;
    }

    final matches = RegExp(r'(19|20)\\d{2}').allMatches(state);
    if (matches.isEmpty) {
      return null;
    }
    final last = matches.last.group(0);
    return last != null ? int.tryParse(last) : null;
  }

  String _getCourseAbbreviation(Course course) {
    if (course.abbreviation != null) {
      return course.abbreviation!;
    }

    if (course.name == null) {
      return '???';
    }

    //TODO: This fix(finished courses the abbreviation is null) works when the
    //app is in portuguese, but not in english. Where instead of LEIC it will be BICE.
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
            bottom: 5,
            top: 10,
            left: 20,
            right: 20,
          ),
          children: [
            Center(
              child: CourseSelection(
                courseInfos: courses.map((course) {
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
              child: GestureDetector(
                onTap: _toggleBlur,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: _blurSensitiveInfo ? 6 : 0,
                    sigmaY: _blurSensitiveInfo ? 6 : 0,
                  ),
                  child: AverageBar(
                    average: course.currentAverage ?? 0,
                    completedCredits: course.finishedEcts ?? 0,
                    totalCredits: _getTotalCredits(profile, course),
                    statusText: course.state ?? '',
                    averageText: S.of(context).average,
                  ),
                ),
              ),
            ),
            CourseUnitsView(course: course),
          ],
        );
      },
      nullContentWidget: LayoutBuilder(
        // Band-aid for allowing refresh on null content
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.only(bottom: 120),
            child: const Center(child: NoCoursesWidget()),
          ),
        ),
      ),
      loadingWidget: const ShimmerCoursesPage(),
      hasContent: (profile) => profile.courses.isNotEmpty,
    );
  }
}
