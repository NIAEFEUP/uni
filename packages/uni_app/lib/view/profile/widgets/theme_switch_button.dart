import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/theme_provider.dart';
import 'package:uni_ui/theme.dart';

class ThemeSwitchButton extends ConsumerWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider.select((value) => value));
    final themeNotifier = ref.read(themeProvider.notifier);

    final icon = switch (themeMode) {
      ThemeMode.light => Icon(
        Icons.wb_sunny, // use uni_ui icons instead
        size: 24,
        color: Theme.of(context).background,
      ),
      ThemeMode.dark => Icon(
        Icons.nightlight_round, // use uni_ui icons instead
        size: 24,
        color: Theme.of(context).background,
      ),
      ThemeMode.system => Icon(
        Icons.brightness_6, // use uni_ui icons instead
        size: 24,
        color: Theme.of(context).background,
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: SizedBox(
        width: 52,
        height: 32,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).primaryVibrant,
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
          onPressed: themeNotifier.setNextTheme,
          child: icon,
        ),
      ),
    );
  }
}
