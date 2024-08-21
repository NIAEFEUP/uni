import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureSwitchTile extends StatefulWidget {
  const FeatureSwitchTile({
    required this.featureFlag,
    super.key,
  });

  final GenericFeatureFlag featureFlag;

  @override
  FeatureSwitchTileState createState() => FeatureSwitchTileState();
}

class FeatureSwitchTileState extends State<FeatureSwitchTile> {
  void refresh() {
    setState(() {});
  }

  Future<void> _onChanged(bool value) async {
    await widget.featureFlag.setEnabled(enabled: value);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.featureFlag.getName(context)),
      trailing: Switch.adaptive(
        value: widget.featureFlag.isEnabled(),
        onChanged: _onChanged,
      ),
    );
  }
}
