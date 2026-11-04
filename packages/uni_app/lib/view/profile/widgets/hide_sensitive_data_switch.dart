import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class HideSensitiveDataSwitch extends StatefulWidget {
  const HideSensitiveDataSwitch({super.key});

  @override
  State<HideSensitiveDataSwitch> createState() =>
      _HideSensitiveDataSwitchState();
}

class _HideSensitiveDataSwitchState extends State<HideSensitiveDataSwitch> {
  bool _hidden = PreferencesController.getHideSensitiveData();

  Future<void> _save(bool value) async {
    setState(() => _hidden = value);
    await PreferencesController.setHideSensitiveData(value: value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Switch.adaptive(
      value: _hidden,
      onChanged: _save,
      activeTrackColor: colors.onSecondary,
      activeThumbColor: colors.secondary,
      inactiveTrackColor: colors.onSecondaryFixed,
      inactiveThumbColor: colors.onSecondary,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
