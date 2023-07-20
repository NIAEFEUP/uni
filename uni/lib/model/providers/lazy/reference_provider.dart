import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/reference_fetcher.dart';
import 'package:uni/controller/local_storage/app_references_database.dart';
import 'package:uni/controller/parsers/parser_references.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class ReferenceProvider extends StateProviderNotifier {
  List<Reference> _references = [];

  ReferenceProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));

  UnmodifiableListView<Reference> get references =>
      UnmodifiableListView(_references);

  @override
  Future<void> loadFromStorage() async {
    final AppReferencesDatabase referencesDb = AppReferencesDatabase();
    final List<Reference> references = await referencesDb.references();
    _references = references;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final referencesAction = Completer<void>();
    await fetchUserReferences(referencesAction, session);
  }

  Future<void> fetchUserReferences(
      Completer<void> action, Session session) async {
    try {
      final response =
          await ReferenceFetcher().getUserReferenceResponse(session);
      final List<Reference> references = await parseReferences(response);

      updateStatus(RequestStatus.successful);

      final referencesDb = AppReferencesDatabase();
      referencesDb.saveNewReferences(references);

      _references = references;
    } catch (e) {
      Logger().e('Failed to get References info');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }
}
