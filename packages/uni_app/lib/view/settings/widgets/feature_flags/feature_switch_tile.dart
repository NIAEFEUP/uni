import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureSwitchTile extends StatelessWidget {
  const FeatureSwitchTile({
    required this.featureFlag,
    required this.refreshDialog,
    super.key,
  });

  final GenericFeatureFlag featureFlag;
  final void Function() refreshDialog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(featureFlag.getName(context)),
      trailing: Switch.adaptive(
        value: featureFlag.isEnabled(),
        onChanged: (value) async {
          await featureFlag.setEnabled(enabled: value);
          refreshDialog();
        },
      ),
    );
  }
}
