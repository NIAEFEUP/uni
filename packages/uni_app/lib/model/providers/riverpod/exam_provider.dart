import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/exam_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

final examProvider = AsyncNotifierProvider<ExamNotifier, List<Exam>?>(
  ExamNotifier.new,
);

class ExamNotifier extends CachedAsyncNotifier<List<Exam>> {
  @override
  Duration? get cacheDuration => const Duration(days: 1);

  @override
  Future<List<Exam>> loadFromStorage() async {
    return Database().exams;
  }

  @override
  Future<List<Exam>?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return null;
    }

    final profile = await ref.watch(profileProvider.future);
    if (profile == null) {
      return null;
    }

    return _fetchUserExams(
      ParserExams(),
      profile,
      session,
      profile.courseUnits,
    );
  }

  Future<List<Exam>> _fetchUserExams(
    ParserExams parser,
    Profile profile,
    Session session,
    List<CourseUnit> userUcs,
  ) async {
    final exams = await ExamFetcher(userUcs).extractExams(session, parser);

    exams.sort((exam1, exam2) => exam1.start.compareTo(exam2.start));
    Database().saveExams(exams);
    return exams;
  }
}
