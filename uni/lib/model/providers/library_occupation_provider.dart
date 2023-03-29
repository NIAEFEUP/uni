import 'dart:async';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/library_occupation_fetcher.dart';
import 'package:uni/controller/local_storage/app_library_occupation_database.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class LibraryOccupationProvider extends StateProviderNotifier {
  LibraryOccupation? _occupation;

  LibraryOccupation? get occupation => _occupation;

  void getLibraryOccupation(
    Session session,
    Completer<void> action,
  ) async {
    try {
      updateStatus(RequestStatus.busy);

      final LibraryOccupation occupation =
          await LibraryOccupationFetcherSheets()
              .getLibraryOccupationFromSheets(session);

      final LibraryOccupationDatabase db = LibraryOccupationDatabase();
      db.saveOccupation(occupation);

      _occupation = occupation;
      notifyListeners();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Occupation: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }

  Future<void> updateStateBasedOnLocalOccupation() async {
    final LibraryOccupationDatabase db = LibraryOccupationDatabase();
    final LibraryOccupation occupation = await db.occupation();

    _occupation = occupation;
    notifyListeners();
  }
}
