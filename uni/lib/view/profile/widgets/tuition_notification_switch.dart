import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class TuitionNotificationSwitch extends StatefulWidget {
  const TuitionNotificationSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _TuitionNotificationSwitchState();
}

class _TuitionNotificationSwitchState extends State<TuitionNotificationSwitch> {
  bool tuitionNotificationToggle = true;

  @override
  void initState() {
    super.initState();
    getTuitionNotificationToggle();
  }

  Future<void> getTuitionNotificationToggle() async {
    await AppSharedPreferences.getTuitionNotificationToggle()
        .then((value) => setState(() => tuitionNotificationToggle = value));
  }

  Future<void> saveTuitionNotificationToggle({required bool value}) async {
    await AppSharedPreferences.setTuitionNotificationToggle(value: value);
    setState(() {
      tuitionNotificationToggle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: tuitionNotificationToggle,
      onChanged: (value) => saveTuitionNotificationToggle(value: value),
    );
  }
}
