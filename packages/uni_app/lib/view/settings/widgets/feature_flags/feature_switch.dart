import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/enabled_feature_controller.dart';

abstract class FeatureSwitch extends StatefulWidget {
  const FeatureSwitch({required this.enabledFeatureController, super.key});

  final EnabledFeatureController enabledFeatureController;

  @override
  FeatureSwitchState createState();
}

abstract class FeatureSwitchState<T extends FeatureSwitch> extends State<T> {
  FeatureSwitchState();

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
