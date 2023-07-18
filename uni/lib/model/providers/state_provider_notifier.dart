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
  bool _initialized;
  DateTime? _lastUpdateTime;
  bool dependsOnSession;
  Duration? cacheDuration;

  RequestStatus get status => _status;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  StateProviderNotifier(
      {required this.dependsOnSession,
      required this.cacheDuration,
      RequestStatus initialStatus = RequestStatus.busy,
      bool initialize = true})
      : _status = initialStatus,
        _initialized = !initialize;

  Future<void> _loadFromStorage() async {
    _lastUpdateTime = await AppSharedPreferences.getLastDataClassUpdateTime(
        runtimeType.toString());

    await loadFromStorage();
    Logger().i("Loaded $runtimeType info from storage");
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
        } else {
          Logger().w(
              "$runtimeType remote load method did not update request status");
        }
      } else {
        Logger().w("No internet connection; skipping $runtimeType remote load");
      }
    } else {
      Logger().i(
          "Last info for $runtimeType is within cache period (last updated on $_lastUpdateTime); "
          "skipping remote load");
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
    await _lock.synchronized(() async {
      if (_lastUpdateTime != null &&
          DateTime.now().difference(_lastUpdateTime!) <
              const Duration(minutes: 1)) {
        Logger().w(
            "Last update for $runtimeType was less than a minute ago; skipping refresh");
        return;
      }

      final session =
          Provider.of<SessionProvider>(context, listen: false).session;
      final profile =
          Provider.of<ProfileProvider>(context, listen: false).profile;

      _loadFromRemote(session, profile, force: true);
    });
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

  /// Loads data from storage into the provider.
  /// This will run once when the provider is first initialized.
  /// If the data is not available in storage, this method should do nothing.
  Future<void> loadFromStorage();

  /// Loads data from the remote server into the provider.
  /// This will run once when the provider is first initialized.
  /// If the data is not available from the remote server
  /// or the data is filled into the provider on demand,
  /// this method should simply set the request status to [RequestStatus.successful];
  /// otherwise, it should set the status accordingly.
  Future<void> loadFromRemote(Session session, Profile profile);
}
