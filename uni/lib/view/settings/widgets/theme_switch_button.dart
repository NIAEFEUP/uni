import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/theme_notifier.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return IconButton(
          icon: switch (themeNotifier.getTheme()) {
            ThemeMode.light => const Icon(Icons.wb_sunny),
            ThemeMode.dark => const Icon(Icons.nightlight_round),
            ThemeMode.system => const Icon(Icons.brightness_6),
          },
          onPressed: themeNotifier.setNextTheme,
        );
      },
    );
  }
}
