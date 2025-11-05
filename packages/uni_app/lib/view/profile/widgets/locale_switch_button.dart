import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/theme.dart';

class LocaleSwitchButton extends ConsumerWidget {
  const LocaleSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider.select((value) => value));
    final localeNotifier = ref.read(localeProvider.notifier);

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
          onPressed: localeNotifier.setNextLocale,
          child: Text(
            locale.localeCode.languageCode.toUpperCase(),
            style: Theme.of(context).titleSmall,
          ),
        ),
      ),
    );
  }
}
