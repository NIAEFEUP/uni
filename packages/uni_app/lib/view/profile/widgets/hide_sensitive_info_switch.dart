import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class HideSensitiveInfoSwitch extends StatefulWidget {
  const HideSensitiveInfoSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _HideSensitiveInfoSwitchState();
}

class _HideSensitiveInfoSwitchState extends State<HideSensitiveInfoSwitch> {
  bool hideSensitiveInfoToggle =
      PreferencesController.getHideSensitiveInfoToggle();

  Future<void> saveHideSensitiveInfoToggle({required bool value}) async {
    await PreferencesController.setHideSensitiveInfoToggle(value: value);
    setState(() {
      hideSensitiveInfoToggle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: hideSensitiveInfoToggle,
      onChanged: (value) => saveHideSensitiveInfoToggle(value: value),
    );
  }
}
