import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/professor_info_fetcher.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final professorInfoProvider = FutureProvider.family<Professor, Professor>((
  ref,
  professor,
) async {
  final session = await ref.read(sessionProvider.future);
  final baseUrls = session != null
      ? List<String>.from(
          session.faculties.map((f) => 'https://sigarra.up.pt/$f/pt/'),
        )
      : <String>[];
  return ProfessorInfoFetcher().fetchProfessorInfo(
    professor,
    session!,
    baseUrls,
  );
});
