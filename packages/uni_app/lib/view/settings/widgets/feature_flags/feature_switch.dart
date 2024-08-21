import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';

class FeatureSwitch extends StatelessWidget {
  const FeatureSwitch({required this.featureFlag, super.key});

  final FeatureFlag featureFlag;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: featureFlag.enabled,
      onChanged: (value) {
        featureFlag.enabled = value;
      },
    );
  }
}
