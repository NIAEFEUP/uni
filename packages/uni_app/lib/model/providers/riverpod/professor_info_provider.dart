import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/academics/professor_info_fetcher.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final professorInfoProvider =
    AsyncNotifierProvider.autoDispose<ProfessorInfoNotifier, Professor?>(
      ProfessorInfoNotifier.new,
    );

class ProfessorInfoNotifier extends CachedAsyncNotifier<Professor?> {
  @override
  Duration? get cacheDuration => const Duration(minutes: 30);

  @override
  Future<Professor?> loadFromStorage() async => null;

  @override
  Future<Professor?> loadFromRemote() async {
    final professor = _professorKey;
    if (professor == null) {
      return null;
    }

    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return null;
    }

    final baseUrls = session.faculties
        .map((f) => 'https://sigarra.up.pt/$f/pt/')
        .toList();

    return ProfessorInfoFetcher().fetchProfessorInfo(
      professor,
      session,
      baseUrls,
    );
  }

  void setProfessor(Professor professor) {
    _professorKey = professor;
  }

  Professor? _professorKey;
}

final professorInfoFamilyProvider = FutureProvider.autoDispose
    .family<Professor?, Professor>((ref, professor) {
      ref.read(professorInfoProvider.notifier).setProfessor(professor);
      return ref.watch(professorInfoProvider.future);
    });
