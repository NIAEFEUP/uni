import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
  RequestStatus _status;
  bool _initialized = false;
  DateTime? _lastUpdateTime;
  bool dependsOnSession;
  Duration? cacheDuration;

  RequestStatus get status => _status;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  StateProviderNotifier(
      {required this.dependsOnSession,
      required this.cacheDuration,
      RequestStatus? initialStatus})
      : _status = initialStatus ?? RequestStatus.busy;

  Future<void> _loadFromStorage() async {
    _lastUpdateTime = await AppSharedPreferences.getLastDataClassUpdateTime(
        runtimeType.toString());

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final sessionIsPersistent =
        userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '';

    if (sessionIsPersistent) {
      await loadFromStorage();
      Logger().i("Loaded $runtimeType info from storage");
    } else {
      Logger().i(
          "Session is not persistent; skipping $runtimeType load from storage");
    }
  }

  Future<void> _loadFromRemote(Session session, Profile profile,
      {bool force = false}) async {
    final bool hasConnectivity =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    final shouldReload = force ||
        _lastUpdateTime == null ||
        cacheDuration == null ||
        DateTime.now().difference(_lastUpdateTime!) > cacheDuration!;

    if (shouldReload) {
      if (hasConnectivity) {
        updateStatus(RequestStatus.busy);
        await loadFromRemote(session, profile);
        if (_status == RequestStatus.successful) {
          Logger().i("Loaded $runtimeType info from remote");
        } else if (_status == RequestStatus.failed) {
          Logger().e("Failed to load $runtimeType info from remote");
        }
      } else {
        Logger().i("No internet connection; skipping $runtimeType remote load");
      }
    } else {
      Logger().i(
          "Last info for $runtimeType is within cache period ($cacheDuration); skipping remote load");
    }

    if (!shouldReload || !hasConnectivity || _status == RequestStatus.busy) {
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

    _loadFromRemote(session, profile, force: true);
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
