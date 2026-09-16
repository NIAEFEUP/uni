import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/academics/schedule/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

/// Fetches the list of lectures for a specific student.
///
/// Optionally filters by lective year if provided.
/// Uses the same deduplication strategy as the main lectureProvider.
final studentLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, (CourseUnitStudent, int?)>((ref, params) async {
      final (student, lectiveYear) = params;

      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }

      final lectures = await ScheduleFetcherNewApiStudent(
        studentNumber: student.number.toString(),
      ).getLectures(session, lectiveYear: lectiveYear);

      // Use the same deduplication as lectureProvider: convert to Set and back
      // This relies on Lecture's equality implementation
      print(lectures.toSet().toList());
      return lectures.toSet().toList();
    });
