import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/reference_fetcher.dart';
import 'package:uni/controller/local_storage/app_references_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/parsers/parser_references.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class ReferenceProvider extends StateProviderNotifier {
  List<Reference> _references = [];

  UnmodifiableListView<Reference> get references =>
      UnmodifiableListView(_references);

  void getUserReferences(
      Completer<void> action,
      Tuple2<String, String> userPersistentInfo,
      Session session) async {
    try {
      if (userPersistentInfo.item1 == '' || userPersistentInfo.item2 == '') {
        return;
      }

      updateStatus(RequestStatus.busy);
      final response = await ReferenceFetcher()
          .getUserReferenceResponse(session);
      final List<Reference> references = await parseReferences(response);
      final String currentTime = DateTime.now().toString();
      await storeRefreshTime('references', currentTime);

      // Store references in the database
      final referencesDb = AppReferencesDatabase();
      referencesDb.saveNewReferences(references);

      _references = references;
      notifyListeners();

      } catch (e) {
        Logger().e('Failed to get References info');
        updateStatus(RequestStatus.failed);
      }

    action.complete();
  }

  void updateStateBasedOnLocalUserReferences() async {
    final AppReferencesDatabase referencesDb = AppReferencesDatabase();
    final List<Reference> references = await referencesDb.references();
    _references = references;
    notifyListeners();
  }

  Future<void> storeRefreshTime(String db, String currentTime) async {
    final AppRefreshTimesDatabase refreshTimesDatabase =
    AppRefreshTimesDatabase();
    refreshTimesDatabase.saveRefreshTime(db, currentTime);
  }
}