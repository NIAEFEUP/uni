import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/professor_info_fetcher.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final professorInfoProvider =
    FutureProvider.autoDispose.family<Professor, Professor>(
  (ref, professor) async {
    final session = await ref.watch(sessionProvider.future);
    if (session == null) {
      throw StateError('No active session available when fetching professor info.');
    }

    final baseUrls = session.faculties
        .map((f) => 'https://sigarra.up.pt/$f/pt/')
        .toList();

    return ProfessorInfoFetcher().fetchProfessorInfo(
      professor,
      session,
      baseUrls,
    );
  },
);
