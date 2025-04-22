import 'dart:async';

import 'package:uni/controller/fetchers/reference_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/controller/parsers/parser_references.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class ReferenceProvider extends StateProviderNotifier<List<Reference>> {
  ReferenceProvider() : super(cacheDuration: const Duration(hours: 1));

  @override
  Future<List<Reference>> loadFromStorage(StateProviders stateProviders) {
    // TODO: Remove this Future.value
    return Future.value(Database().references);
  }

  @override
  Future<List<Reference>> loadFromRemote(StateProviders stateProviders) async {
    final session = stateProviders.sessionProvider.state!;

    final response = await ReferenceFetcher().getUserReferenceResponse(session);
    final references = await parseReferences(response);

    Database().saveReferences(references);

    return references;
  }
}
