import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/providers/riverpod/hide_sensitive_data_provider.dart';

class HideSensitiveDataSwitch extends ConsumerWidget {
  const HideSensitiveDataSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return Switch.adaptive(
      value: ref.watch(hideSensitiveDataProvider),
      onChanged: ref.read(hideSensitiveDataProvider.notifier).setHidden,
      activeTrackColor: colors.onSecondary,
      activeThumbColor: colors.secondary,
      inactiveTrackColor: colors.onSecondaryFixed,
      inactiveThumbColor: colors.onSecondary,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
