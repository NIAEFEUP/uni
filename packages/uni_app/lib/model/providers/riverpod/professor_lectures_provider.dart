import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

/// Parameters for fetching professor lectures.
class ProfessorLecturesParams {
  ProfessorLecturesParams({required this.professor, this.lectiveYear});

  final Professor professor;
  final int? lectiveYear;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ProfessorLecturesParams &&
        other.professor == professor &&
        other.lectiveYear == lectiveYear;
  }

  @override
  int get hashCode => Object.hash(professor, lectiveYear);
}

/// Fetches the list of lectures for a specific professor.
///
/// Optionally filters by lective year if provided.
/// Deduplicates lectures taught to multiple classes.
final professorLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, ProfessorLecturesParams>((ref, params) async {
      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }
      final lectures = await ScheduleFetcherNewApiProfessor(
        professorCode: params.professor.code,
      ).getLectures(session, lectiveYear: params.lectiveYear);

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
