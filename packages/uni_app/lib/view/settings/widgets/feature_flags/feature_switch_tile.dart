import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/feature_flag_group.dart';
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
    return widget.featureFlag is FeatureFlag
        ? ListTile(
            title: Text(widget.featureFlag.getName(context)),
            trailing: Switch.adaptive(
              value: widget.featureFlag.isEnabled(),
              onChanged: _onChanged,
            ),
          )
        : Column(
            children: [
              ListTile(
                title: Text(
                  widget.featureFlag.getName(context),
                ),
                trailing: Switch.adaptive(
                  value: widget.featureFlag.isEnabled(),
                  onChanged: _onChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: (widget.featureFlag as FeatureFlagGroup)
                      .getFeatureFlags()
                      .map(
                        (featureFlag) =>
                            FeatureSwitchTile(featureFlag: featureFlag),
                      )
                      .toList(),
                ),
              ),
            ],
          );
  }
}
