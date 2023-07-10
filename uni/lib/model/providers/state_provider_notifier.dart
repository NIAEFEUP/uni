import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/request_status.dart';

abstract class StateProviderNotifier extends ChangeNotifier {
  static final Lock _lock = Lock();
  RequestStatus _status = RequestStatus.busy;
  bool _initialized = false;
  DateTime? _lastUpdateTime;
  bool dependsOnSession;

  RequestStatus get status => _status;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  StateProviderNotifier({required this.dependsOnSession});

  Future<void> _loadFromStorage() async {
    _lastUpdateTime = await AppSharedPreferences.getLastDataClassUpdateTime(
        runtimeType.toString());

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final sessionIsPersistent =
        userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '';
    if (sessionIsPersistent) {
      await loadFromStorage();
    }
  }

  Future<void> _loadFromRemote(Session session, Profile profile) async {
    final bool hasConnectivity =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    if (hasConnectivity) {
      updateStatus(RequestStatus.busy);
      await loadFromRemote(session, profile);
    }

    if (!hasConnectivity || _status == RequestStatus.busy) {
      // No online activity from provider
      updateStatus(RequestStatus.successful);
    } else {
      _lastUpdateTime = DateTime.now();
      await AppSharedPreferences.setLastDataClassUpdateTime(
          runtimeType.toString(), _lastUpdateTime!);
      notifyListeners();
    }
  }

  void updateStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> forceRefresh(BuildContext context) async {
    final session =
        Provider.of<SessionProvider>(context, listen: false).session;
    final profile =
        Provider.of<ProfileProvider>(context, listen: false).profile;

    _loadFromRemote(session, profile);
  }

  Future<void> ensureInitialized(Session session, Profile profile) async {
    await _lock.synchronized(() async {
      if (_initialized) {
        return;
      }

      _initialized = true;

      await _loadFromStorage();
      await _loadFromRemote(session, profile);
    });
  }

  Future<void> loadFromStorage();

  Future<void> loadFromRemote(Session session, Profile profile);
}
