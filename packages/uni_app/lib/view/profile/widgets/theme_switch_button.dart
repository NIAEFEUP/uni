import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/theme_notifier.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final icon = switch (themeNotifier.getTheme()) {
          ThemeMode.light => Icon(
              Icons.wb_sunny,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ThemeMode.dark => Icon(
              Icons.nightlight_round,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ThemeMode.system => Icon(
              Icons.brightness_6,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
        };
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          child: SizedBox(
            width: 52,
            height: 32,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: themeNotifier.setNextTheme,
              child: icon,
            ),
          ),
        );
      },
    );
  }
}
