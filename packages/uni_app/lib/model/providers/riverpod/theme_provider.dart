import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(PreferencesController.getThemeMode()),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(super.initialTheme);

  ThemeMode getTheme() => state;

  void setNextTheme() {
    final nextThemeMode = (state.index + 1) % 3;
    setTheme(ThemeMode.values[nextThemeMode]);
  }

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
    PreferencesController.setThemeMode(themeMode);
  }
}
