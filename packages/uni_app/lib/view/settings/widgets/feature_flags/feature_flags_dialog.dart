import 'package:flutter/material.dart';
import 'package:uni/controller/feature_flags/feature_flag_table.dart';

import 'package:uni/generated/l10n.dart';
import 'package:uni/view/settings/widgets/feature_flags/feature_switch_tile.dart';

class FeatureFlagsDialog extends StatefulWidget {
  const FeatureFlagsDialog({super.key});

  @override
  FeatureFlagsDialogState createState() => FeatureFlagsDialogState();
}

class FeatureFlagsDialogState extends State<FeatureFlagsDialog> {
  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).feature_flags),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: FeatureFlagTable.getFeatureFlags()
            .map(
              (featureFlag) => FeatureSwitchTile(
                featureFlag: featureFlag,
                refreshDialog: refresh,
              ),
            )
            .toList(),
      ),
    );
  }
}
