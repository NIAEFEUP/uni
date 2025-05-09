import 'dart:async';

import 'package:uni/controller/fetchers/library_occupation_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
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
    final occupation = LibraryOccupation(0, 0);

    Database().libraryOccupations.forEach(occupation.addFloor);

    return occupation;
  }

  @override
  Future<LibraryOccupation> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    final occupation = await LibraryOccupationFetcher().getLibraryOccupation();

    Database().saveLibraryOccupations(occupation.floors);

    return occupation;
  }
}
