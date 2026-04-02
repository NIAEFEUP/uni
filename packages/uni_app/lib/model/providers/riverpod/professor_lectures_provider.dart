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
    if (identical(this, other)) return true;
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
final professorLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, ProfessorLecturesParams>((ref, params) async {
      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }
      return ScheduleFetcherNewApiProfessor(
        professorCode: params.professor.code,
      ).getLectures(session, lectiveYear: params.lectiveYear);
    });
