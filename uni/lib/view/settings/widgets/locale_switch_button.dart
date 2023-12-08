import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/locale_notifier.dart';

class LocaleSwitchButton extends StatelessWidget {
  const LocaleSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
        return ElevatedButton(
          onPressed: () => localeNotifier.setNextLocale(),
          child: Text(
            localeNotifier.getLocale().localeCode.languageCode.toUpperCase(),
          ),
        );
      },
    );
  }
}
