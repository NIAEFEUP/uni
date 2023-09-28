import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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

  void markAsInitialized() {
    _initializedFromStorage = true;
    _initializedFromRemote = true;
    _status = RequestStatus.successful;
    _lastUpdateTime = DateTime.now();
    notifyListeners();
  }

  void markAsNotInitialized() {
    _initializedFromStorage = false;
    _initializedFromRemote = false;
    _status = _initialStatus;
    _lastUpdateTime = null;
    notifyListeners();
  }

  void _updateStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    Logger().d('Loading $runtimeType info from storage');

    _lastUpdateTime = await AppSharedPreferences.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    try {
      await loadFromStorage();
      notifyListeners();
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      Logger()
          .e('Failed to load $runtimeType info from storage: $e\n$stackTrace');
    }

    Logger().i('Loaded $runtimeType info from storage');
  }

  Future<void> _loadFromRemote(
    Session session,
    Profile profile, {
    bool force = false,
  }) async {
    Logger().d('Loading $runtimeType info from remote');

    final shouldReload = force ||
        _lastUpdateTime == null ||
        cacheDuration == null ||
        DateTime.now().difference(_lastUpdateTime!) > cacheDuration!;

    if (!shouldReload) {
      Logger().d('Last info for $runtimeType is within cache period '
          '(last updated on $_lastUpdateTime); skipping remote load');
      _updateStatus(RequestStatus.successful);
      return;
    }

    final hasConnectivity =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    if (!hasConnectivity) {
      Logger().w('No internet connection; skipping $runtimeType remote load');
      _updateStatus(RequestStatus.successful);
      return;
    }

    _updateStatus(RequestStatus.busy);

    try {
      await loadFromRemote(session, profile);

      Logger().i('Loaded $runtimeType info from remote');
      _lastUpdateTime = DateTime.now();
      _updateStatus(RequestStatus.successful);

      await AppSharedPreferences.setLastDataClassUpdateTime(
        runtimeType.toString(),
        _lastUpdateTime!,
      );
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      Logger()
          .e('Failed to load $runtimeType info from remote: $e\n$stackTrace');
      _updateStatus(RequestStatus.failed);
    }
  }

  Future<void> forceRefresh(BuildContext context) async {
    await _lock.synchronized(() async {
      final session = context.read<SessionProvider>().session;
      final profile = context.read<ProfileProvider>().profile;
      _updateStatus(RequestStatus.busy);
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

      final session = context.read<SessionProvider>().session;
      final profile = context.read<ProfileProvider>().profile;

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
  /// This method must not catch data loading errors.
  Future<void> loadFromRemote(Session session, Profile profile);
}
