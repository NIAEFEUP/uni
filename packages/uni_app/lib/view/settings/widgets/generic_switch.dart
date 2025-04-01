import 'package:flutter/material.dart';

abstract class GenericSwitch extends StatefulWidget {
  const GenericSwitch({super.key});

  @override
  GenericSwitchState createState();
}

abstract class GenericSwitchState<T extends GenericSwitch> extends State<T> {
  GenericSwitchState();

  @override
  void initState() {
    super.initState();
    value = initializeValue();
  }

  late bool value;
  bool initializeValue();
  Future<void> storeValue({required bool value});

  Future<void> changeValue({required bool value}) async {
    await storeValue(value: value);
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: (value) => changeValue(value: value),
    );
  }
}
