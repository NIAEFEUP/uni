import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class TuitionNotificationSwitch extends StatefulWidget {
  const TuitionNotificationSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _TuitionNotificationSwitchState();
}

class _TuitionNotificationSwitchState extends State<TuitionNotificationSwitch> {
  bool tuitionNotificationToggle =
      PreferencesController.getTuitionNotificationToggle();

  Future<void> saveTuitionNotificationToggle({required bool value}) async {
    await PreferencesController.setTuitionNotificationToggle(value: value);
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
