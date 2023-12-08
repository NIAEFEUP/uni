import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/locale_notifier.dart';

class LocaleSwitchButton extends StatelessWidget {
  const LocaleSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
        return TextButton(
          onPressed: () => localeNotifier.setNextLocale(),
          style: TextButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 5),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Text(
              localeNotifier.getLocale().localeCode.languageCode.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }
}
