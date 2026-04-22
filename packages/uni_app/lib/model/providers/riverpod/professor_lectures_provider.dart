import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

/// Fetches the list of lectures for a specific professor.
///
/// Optionally filters by lective year if provided.
/// Deduplicates lectures taught to multiple classes.
/// Family parameter: (professor, lectiveYear?)
final professorLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, (Professor, int?)>((ref, params) async {
      final (professor, lectiveYear) = params;

      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }
      final lectures = await ScheduleFetcherNewApiProfessor(
        professorCode: professor.code,
      ).getLectures(session, lectiveYear: lectiveYear);

      // Deduplicate lectures that are taught to multiple classes
      final seen = <String>{};
      final uniqueLectures = <Lecture>[];

      for (final lecture in lectures) {
        // Create a unique key based on time and content
        final key =
            '${lecture.startTime}|${lecture.endTime}|${lecture.subject}|${lecture.room}|${lecture.typeClass}';

        if (!seen.contains(key)) {
          seen.add(key);
          uniqueLectures.add(lecture);
        }
      }

      return uniqueLectures;
    });
