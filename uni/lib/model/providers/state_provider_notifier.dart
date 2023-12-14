import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/request_status.dart';

abstract class StateProviderNotifier<T> extends ChangeNotifier {
  StateProviderNotifier({
    required this.cacheDuration,
    this.dependsOnSession = true,
  });

  /// The model that this notifier provides.
  /// This future will throw if the data loading fails.
  T? _state;

  /// Whether this provider depends on Session and Profile to fetch data.
  bool dependsOnSession;

  /// The data loading request status.
  RequestStatus _requestStatus = RequestStatus.none;

  /// The timeout for concurrent state change operations.
  static const _lockTimeout = Duration(seconds: 30);

  /// The lock for concurrent state change operations.
  final Lock _lock = Lock();

  /// The last time the model was fetched from the remote.
  DateTime? _lastUpdateTime;

  /// The maximum time after the last update from the remote
  /// to retrieve cached data.
  Duration? cacheDuration;

  RequestStatus get requestStatus => _requestStatus;

  T? get state => _state;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  /// Gets the model from the local database.
  /// This method such not catch data loading errors.
  Future<T> loadFromStorage();

  /// Gets the model from the remote server.
  /// This will run once when the provider is first initialized.
  /// This method must not catch data loading errors.
  /// This method should save data in the database, if appropriate.
  Future<T> loadFromRemote(Session session, Profile profile);

  /// Update the current model state, notifying the listeners.
  /// This should be called only to modify the model after
  /// it has been loaded, for example as a UI callback side effect.
  void updateState(T newState) {
    _state = newState;
    notifyListeners();
  }

  /// Makes the state null, as if the model has never been loaded,
  /// so that consumers may trigger the loading again.
  void invalidate() {
    _state = null;
  }

  Future<void> _loadFromStorage() async {
    Logger().d('Loading $runtimeType info from storage');

    _updateStatus(RequestStatus.busy);

    _lastUpdateTime = PreferencesController.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    try {
      updateState(await loadFromStorage());
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      Logger()
          .e('Failed to load $runtimeType info from storage: $e\n$stackTrace');
      _updateStatus(RequestStatus.failed);
    }

    Logger().i('Loaded $runtimeType info from storage');
  }

  Future<void> _loadFromRemote(
    Session session,
    Profile profile, {
    bool force = false,
  }) async {
    Logger().d('Loading $runtimeType info from remote');

    _updateStatus(RequestStatus.busy);

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

    try {
      updateState(await loadFromRemote(session, profile));

      Logger().i('Loaded $runtimeType info from remote');
      _lastUpdateTime = DateTime.now();

      await PreferencesController.setLastDataClassUpdateTime(
        runtimeType.toString(),
        _lastUpdateTime!,
      );

      _updateStatus(RequestStatus.successful);
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      Logger()
          .e('Failed to load $runtimeType info from remote: $e\n$stackTrace');
      _updateStatus(RequestStatus.failed);
    }
  }

  void _updateStatus(RequestStatus newStatus) {
    _requestStatus = newStatus;
    notifyListeners();
  }

  Future<void> forceRefresh(BuildContext context) async {
    await _lock.synchronized(
      () async {
        if (!context.mounted) {
          return;
        }
        final session = context.read<SessionProvider>().state!;
        final profile = context.read<ProfileProvider>().state!;
        await _loadFromRemote(session, profile, force: true);
      },
      timeout: _lockTimeout,
    );
  }

  Future<void> ensureInitialized(BuildContext context) async {
    await _lock.synchronized(
      () async {
        if (!context.mounted || _state != null) {
          return;
        }

        await _loadFromStorage();

        if (context.mounted) {
          final session = context.read<SessionProvider>().state!;
          final profile = context.read<ProfileProvider>().state!;
          await _loadFromRemote(session, profile);
        }
      },
      timeout: _lockTimeout,
    );
  }
}
