import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/theme_notifier.dart';

class ThemeSwitchButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return IconButton(
          icon: getThemeIcon(themeNotifier.getTheme()),
          onPressed: themeNotifier.setNextTheme,
        );
      },
    );
  }
}
