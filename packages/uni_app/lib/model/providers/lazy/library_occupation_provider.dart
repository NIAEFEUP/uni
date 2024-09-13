import 'dart:async';

import 'package:uni/controller/fetchers/library_occupation_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_library_occupation_database.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class LibraryOccupationProvider
    extends StateProviderNotifier<LibraryOccupation> {
  LibraryOccupationProvider() : super(cacheDuration: const Duration(hours: 1));

  @override
  Future<LibraryOccupation> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    final db = LibraryOccupationDatabase();
    return db.occupation();
  }

  @override
  Future<LibraryOccupation> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    final occupation = await LibraryOccupationFetcher().getLibraryOccupation();
    final db = LibraryOccupationDatabase();
    unawaited(db.saveIfPersistentSession(occupation));

    return occupation;
  }
}
