import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Future<T?> build() async {
    _lastUpdateTime = PreferencesController.getLastDataClassUpdateTime(
      runtimeType.toString(),
    );

    final localData = await loadFromStorage();
    if (localData != null) {
      state = AsyncData(localData);
      _lastUpdateTime ??= DateTime.now();
    }

    if (localData == null || !_isCacheValid) {
      try {
        final remoteData = await loadFromRemote();
        if (remoteData != null) {
          _lastUpdateTime = DateTime.now();
          state = AsyncData(remoteData);
          return remoteData;
        }
      } catch (err, st) {
        state = AsyncError(err, st);
        rethrow;
      }
    }

    return localData;
  }

  Future<T?> refreshRemote() async {
    try {
      final remoteData = await loadFromRemote();
      if (remoteData != null) {
        _lastUpdateTime = DateTime.now();
        state = AsyncData(remoteData);
      }

      return remoteData;
    } catch (err, st) {
      state = AsyncError(err, st);
      rethrow;
    }
  }

  void updateState(T newState) {
    state = AsyncData(newState);
    _lastUpdateTime = DateTime.now();
  }

  void invalidate() {
    state = AsyncData(null);
    _lastUpdateTime = null;
  }
}
