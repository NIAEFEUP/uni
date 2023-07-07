import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/request_status.dart';

abstract class StateProviderNotifier extends ChangeNotifier {
  RequestStatus _status = RequestStatus.none;
  bool _initialized = false;
  DateTime? _lastUpdateTime;

  RequestStatus get status => _status;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  void updateStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> ensureInitialized(Session session, Profile profile) async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    updateStatus(RequestStatus.busy);

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final sessionIsPersistent =
        userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '';
    if (sessionIsPersistent) {
      await loadFromStorage();
    }

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      await loadFromRemote(session, profile);
    }

    notifyListeners();
  }

  Future<void> loadFromStorage();

  Future<void> loadFromRemote(Session session, Profile profile);
}
