import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/locale_notifier.dart';

class LocaleSwitchButton extends StatelessWidget {
  const LocaleSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
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
                    Theme.of(context).colorScheme.primary),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () => localeNotifier.setNextLocale(),
              child: Text(
                localeNotifier
                    .getLocale()
                    .localeCode
                    .languageCode
                    .toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
