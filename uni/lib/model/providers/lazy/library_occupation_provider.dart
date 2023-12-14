import 'dart:async';

import 'package:uni/controller/fetchers/library_occupation_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_library_occupation_database.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LibraryOccupationProvider
    extends StateProviderNotifier<LibraryOccupation> {
  LibraryOccupationProvider() : super(cacheDuration: const Duration(hours: 1));

  @override
  Future<LibraryOccupation> loadFromStorage() async {
    final db = LibraryOccupationDatabase();
    return db.occupation();
  }

  @override
  Future<LibraryOccupation> loadFromRemote(
    Session session,
    Profile profile,
  ) async {
    final occupation = await LibraryOccupationFetcherSheets()
        .getLibraryOccupationFromSheets(session);

    final db = LibraryOccupationDatabase();
    unawaited(db.saveOccupation(occupation));

    return occupation;
  }
}
