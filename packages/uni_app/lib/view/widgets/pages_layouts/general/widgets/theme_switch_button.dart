import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/theme_provider.dart';

class ThemeSwitchButton extends ConsumerWidget {
  const ThemeSwitchButton({super.key});

  Icon getThemeIcon(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return const Icon(Icons.wb_sunny);
      case ThemeMode.dark:
        return const Icon(Icons.nightlight_round);
      case ThemeMode.system:
        return const Icon(Icons.brightness_6);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return IconButton(
      icon: getThemeIcon(themeMode),
      onPressed: themeNotifier.setNextTheme,
    );
  }
}
