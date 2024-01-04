import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class UsageStatsSwitch extends StatefulWidget {
  const UsageStatsSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _UsageStatsSwitchState();
}

class _UsageStatsSwitchState extends State<UsageStatsSwitch> {
  bool usageStatsToggle = PreferencesController.getUsageStatsToggle();

  Future<void> saveUsageStatsToggle({required bool value}) async {
    await PreferencesController.setUsageStatsToggle(value: value);
    setState(() {
      usageStatsToggle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: usageStatsToggle,
      onChanged: (value) => saveUsageStatsToggle(value: value),
    );
  }
}
