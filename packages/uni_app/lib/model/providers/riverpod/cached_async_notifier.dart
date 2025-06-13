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

  void _updateState(T? newState) {
    if (newState == null) {
      state = const AsyncData(null);
      return;
    }

    state = AsyncData(newState);
    _lastUpdateTime = DateTime.now();
    PreferencesController.setLastDataClassUpdateTime(
      runtimeType.toString(),
      _lastUpdateTime!,
    );
  }

  void _updateError(Object error, [StackTrace? stackTrace]) {
    state = AsyncError(error, stackTrace ?? StackTrace.current);
    Logger().e(
      'Error in $runtimeType: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<T?> _safeExecute(Future<T?> Function() operation) async {
    try {
      final result = await operation();
      if (result != null) {
        _updateState(result);
      }
      return result;
    } catch (err, st) {
      _updateError(err, st);
      rethrow;
    }
  }

  @override
  Future<T?> build() async {
    _lastUpdateTime = PreferencesController.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    Logger().d('Loading $runtimeType from storage...');
    final localData = await _safeExecute(loadFromStorage);

    if (localData != null) {
      Logger().d('✅ Loaded $runtimeType from storage!');
    }

    if (localData == null || !_isCacheValid) {
      if (!_isCacheValid) {
        Logger().d('$runtimeType cache is invalid');
      }
      Logger().d('Loading $runtimeType from remote...');
      final remoteData = await _safeExecute(loadFromRemote);
      if (remoteData != null) {
        Logger().d('✅ Loaded $runtimeType from remote!');
        return remoteData;
      }
    }

    return localData;
  }

  Future<T?> refreshRemote() {
    return _safeExecute(loadFromRemote);
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
