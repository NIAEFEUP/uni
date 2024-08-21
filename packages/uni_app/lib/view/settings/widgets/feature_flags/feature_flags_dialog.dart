import 'package:flutter/material.dart';
import 'package:uni/controller/feature_flags/feature_flag_controller.dart';

import 'package:uni/generated/l10n.dart';
import 'package:uni/view/settings/widgets/feature_flags/feature_switch_tile.dart';

class FeatureFlagsDialog extends StatelessWidget {
  const FeatureFlagsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).feature_flags),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: FeatureFlagController.getFeatureFlags()
            .map((featureFlag) => FeatureSwitchTile(featureFlag: featureFlag))
            .toList(),
      ),
    );
  }
}
