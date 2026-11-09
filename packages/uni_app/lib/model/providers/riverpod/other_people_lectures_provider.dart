import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/academics/schedule/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

/// Fetches the list of lectures for a specific professor.
///
/// Optionally filters by lective year if provided.
/// Uses the same deduplication strategy as the main lectureProvider.
final otherPeopleLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, (Object, int?)>((ref, params) async {
      final (person, lectiveYear) = params;

      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }

      final lectures = switch (person) {
        final Professor p => await ScheduleFetcherNewApiProfessor(
          professorCode: p.code,
        ).getLectures(session, lectiveYear: lectiveYear),
        final CourseUnitStudent s => await ScheduleFetcherNewApiStudent(
          studentNumber: s.number.toString(),
        ).getLectures(session, lectiveYear: lectiveYear),
        _ => throw ArgumentError('Expected a Professor or a Student'),
      };

      // Use the same deduplication as lectureProvider: convert to Set and back
      // This relies on Lecture's equality implementation
      return lectures.toSet().toList();
    });
