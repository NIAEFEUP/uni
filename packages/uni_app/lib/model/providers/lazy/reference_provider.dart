import 'dart:async';

import 'package:uni/controller/fetchers/reference_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_references_database.dart';
import 'package:uni/controller/parsers/parser_references.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class ReferenceProvider extends StateProviderNotifier<List<Reference>> {
  ReferenceProvider() : super(cacheDuration: const Duration(hours: 1));

  @override
  Future<List<Reference>> loadFromStorage(StateProviders stateProviders) {
    final referencesDb = AppReferencesDatabase();
    return referencesDb.references();
  }

  @override
  Future<List<Reference>> loadFromRemote(StateProviders stateProviders) async {
    final session = stateProviders.sessionProvider.state!;

    final response = await ReferenceFetcher().getUserReferenceResponse(session);
    final references = await parseReferences(response);

    final referencesDb = AppReferencesDatabase();
    unawaited(referencesDb.saveNewReferences(references));

    return references;
  }
}
