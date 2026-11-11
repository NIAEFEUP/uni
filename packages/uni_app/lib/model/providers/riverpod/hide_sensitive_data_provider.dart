import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

final hideSensitiveDataProvider =
    StateNotifierProvider<HideSensitiveDataNotifier, bool>(
      (ref) => HideSensitiveDataNotifier(),
    );

class HideSensitiveDataNotifier extends StateNotifier<bool> {
  HideSensitiveDataNotifier()
    : super(PreferencesController.getHideSensitiveData());

  Future<void> setHidden(bool hidden) async {
    state = hidden;
    await PreferencesController.setHideSensitiveData(value: hidden);
  }
}
