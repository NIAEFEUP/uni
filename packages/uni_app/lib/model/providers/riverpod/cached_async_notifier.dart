import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

abstract class CachedAsyncNotifier<T> extends AsyncNotifier<T?> {
  Duration? get cacheDuration;

  Future<T?> loadFromStorage();

  Future<T?> loadFromRemote();

  DateTime? _lastUpdateTime;

  bool get _isCacheValid {
    if (_lastUpdateTime == null || cacheDuration == null) {
      return false;
    }
    return DateTime.now().difference(_lastUpdateTime!) < cacheDuration!;
  }

  // FIXME: this is probably not the best way to do this, but in case of an empty list,
  // we cannot differentiate between a list that is indeed empty and a list that is not loaded yet
  bool _invalidLocalData(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is List) {
      return value.isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }
    return false;
  }

  void _updateState(T? newState, {bool updateTimestamp = true}) {
    if (!ref.mounted) {
      return;
    }

    state = AsyncData(newState);
    if (newState != null && updateTimestamp) {
      _lastUpdateTime = DateTime.now();
      PreferencesController.setLastDataClassUpdateTime(
        runtimeType.toString(),
        _lastUpdateTime!,
      );
    }
  }

  void _updateError(Object error, [StackTrace? stackTrace]) {
    if (!ref.mounted) {
      return;
    }

    state = AsyncError(error, stackTrace ?? StackTrace.current);
    Logger().e(
      'Error in $runtimeType: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<T?> _safeExecute(
    Future<T?> Function() operation, {
    bool updateTimestamp = true,
  }) async {
    try {
      final result = await operation();
      if (result != null && ref.mounted && !_invalidLocalData(result)) {
        _updateState(result, updateTimestamp: updateTimestamp);
      }
      return result;
    } catch (err, st) {
      if (ref.mounted) {
        _updateError(err, st);
      }
      rethrow;
    }
  }

  @override
  Future<T?> build() async {
    _lastUpdateTime = PreferencesController.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    Logger().d('Loading $runtimeType from storage...');
    final localData = await _safeExecute(
      loadFromStorage,
      updateTimestamp: false,
    );

    if (localData != null) {
      Logger().d('✅ Loaded $runtimeType from storage!');
    }

    if (_invalidLocalData(localData) || !_isCacheValid) {
      if (!_isCacheValid) {
        Logger().d('$runtimeType cache is invalid');
      }
      return refreshRemote();
    }

    return localData;
  }

  Future<T?> refreshRemote() async {
    Logger().d('Refreshing $runtimeType from remote...');
    try {
      state = const AsyncLoading();
      final result = await loadFromRemote();

      if (!ref.mounted) {
        return result;
      }

      if (result != null) {
        _updateState(result);
        Logger().d('✅ Refreshed $runtimeType from remote!');
        return result;
      }

      return _handleRemoteFailure(
        'Failed to refresh $runtimeType: No valid cache and remote fetch failed',
      );
    } catch (err, st) {
      return _handleRemoteFailure(err, st);
    }
  }

  T? _handleRemoteFailure(Object error, [StackTrace? stackTrace]) {
    final cachedValue = state.value;
    if (cachedValue != null && !_invalidLocalData(cachedValue)) {
      Logger().w('Falling back to cached data for $runtimeType due to: $error');
      _updateState(cachedValue, updateTimestamp: false);
      return cachedValue;
    }

    _updateError(error, stackTrace);
    return null;
  }

  void updateState(T newState) {
    _updateState(newState);
  }

  void invalidate() {
    state = const AsyncData(null);
    _lastUpdateTime = null;
    PreferencesController.setLastDataClassUpdateTime(
      runtimeType.toString(),
      DateTime.now(),
    );
  }
}
