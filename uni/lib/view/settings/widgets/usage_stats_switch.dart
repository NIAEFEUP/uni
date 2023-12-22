import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class UsageStatsSwitch extends StatefulWidget {
  const UsageStatsSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _UsageStatsSwitchState();
}

class _UsageStatsSwitchState extends State<UsageStatsSwitch> {
  bool usageStatsToggle = true;

  @override
  void initState() {
    super.initState();
    getUsageStatsToggle();
  }

  Future<void> getUsageStatsToggle() async {
    await AppSharedPreferences.getUsageStatsToggle()
        .then((value) => setState(() => usageStatsToggle = value));
  }

  Future<void> saveUsageStatsToggle({required bool value}) async {
    await AppSharedPreferences.setUsageStatsToggle(value: value);
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
