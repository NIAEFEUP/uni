import 'dart:async';
import 'dart:collection';

import 'package:uni/controller/fetchers/reference_fetcher.dart';
import 'package:uni/controller/local_storage/app_references_database.dart';
import 'package:uni/controller/parsers/parser_references.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class ReferenceProvider extends StateProviderNotifier {
  ReferenceProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  List<Reference> _references = [];

  UnmodifiableListView<Reference> get references =>
      UnmodifiableListView(_references);

  @override
  Future<void> loadFromStorage() async {
    final referencesDb = AppReferencesDatabase();
    final references = await referencesDb.references();
    _references = references;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserReferences(session);
  }

  Future<void> fetchUserReferences(Session session) async {
    final response = await ReferenceFetcher().getUserReferenceResponse(session);

    _references = await parseReferences(response);

    final referencesDb = AppReferencesDatabase();
    unawaited(referencesDb.saveNewReferences(references));
  }
}
