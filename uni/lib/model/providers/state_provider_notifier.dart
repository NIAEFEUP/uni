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
  StateProviderNotifier({
    required this.cacheDuration,
    this.dependsOnSession = true,
    RequestStatus initialStatus = RequestStatus.busy,
    bool initialize = true,
  })  : _initialStatus = initialStatus,
        _status = initialStatus,
        _initializedFromStorage = !initialize,
        _initializedFromRemote = !initialize;

  final Lock _lock = Lock();
  final RequestStatus _initialStatus;
  RequestStatus _status;
  bool _initializedFromStorage;
  bool _initializedFromRemote;
  DateTime? _lastUpdateTime;
  bool dependsOnSession;
  Duration? cacheDuration;

  RequestStatus get status => _status;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  void markAsNotInitialized() {
    _initializedFromStorage = false;
    _initializedFromRemote = false;
    _status = _initialStatus;
    _lastUpdateTime = null;
  }

  Future<void> _loadFromStorage() async {
    _lastUpdateTime = await AppSharedPreferences.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    await loadFromStorage();
    notifyListeners();
    Logger().i('Loaded $runtimeType info from storage');
  }

  Future<void> _loadFromRemote(
    Session session,
    Profile profile, {
    bool force = false,
  }) async {
    final shouldReload = force ||
        _lastUpdateTime == null ||
        cacheDuration == null ||
        DateTime.now().difference(_lastUpdateTime!) > cacheDuration!;

    if (!shouldReload) {
      Logger().d('Last info for $runtimeType is within cache period '
          '(last updated on $_lastUpdateTime); skipping remote load');
      updateStatus(RequestStatus.successful);
      return;
    }

    final hasConnectivity =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    if (!hasConnectivity) {
      Logger().w('No internet connection; skipping $runtimeType remote load');
      updateStatus(RequestStatus.successful);
      return;
    }

    updateStatus(RequestStatus.busy);

    await loadFromRemote(session, profile);

    if (_status == RequestStatus.successful) {
      Logger().i('Loaded $runtimeType info from remote');
      _lastUpdateTime = DateTime.now();
      notifyListeners();
      await AppSharedPreferences.setLastDataClassUpdateTime(
        runtimeType.toString(),
        _lastUpdateTime!,
      );
    } else if (_status == RequestStatus.failed) {
      Logger().e('Failed to load $runtimeType info from remote');
    } else {
      Logger()
          .w('$runtimeType remote load method did not update request status');
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
          'Last update for $runtimeType was less than a minute ago; '
          'skipping refresh',
        );
        return;
      }

      final session =
          Provider.of<SessionProvider>(context, listen: false).session;
      final profile =
          Provider.of<ProfileProvider>(context, listen: false).profile;

      await _loadFromRemote(session, profile, force: true);
    });
  }

  Future<void> ensureInitialized(BuildContext context) async {
    await ensureInitializedFromStorage();

    if (context.mounted) {
      await ensureInitializedFromRemote(context);
    }
  }

  Future<void> ensureInitializedFromRemote(BuildContext context) async {
    await _lock.synchronized(() async {
      if (_initializedFromRemote) {
        return;
      }

      _initializedFromRemote = true;

      final session =
          Provider.of<SessionProvider>(context, listen: false).session;
      final profile =
          Provider.of<ProfileProvider>(context, listen: false).profile;

      await _loadFromRemote(session, profile);
    });
  }

  /// Loads data from storage into the provider.
  /// This will run once when the provider is first initialized.
  /// If the data is not available in storage, this method should do nothing.
  Future<void> ensureInitializedFromStorage() async {
    await _lock.synchronized(() async {
      if (_initializedFromStorage) {
        return;
      }

      _initializedFromStorage = true;
      await _loadFromStorage();
    });
  }

  Future<void> loadFromStorage();

  /// Loads data from the remote server into the provider.
  /// This will run once when the provider is first initialized.
  /// If the data is not available from the remote server
  /// or the data is filled into the provider on demand,
  /// this method should simply set the
  /// request status to [RequestStatus.successful];
  /// otherwise, it should set the status accordingly.
  Future<void> loadFromRemote(Session session, Profile profile);
}
