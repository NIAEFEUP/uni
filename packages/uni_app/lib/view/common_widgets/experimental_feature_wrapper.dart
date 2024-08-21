import 'package:flutter/cupertino.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class ExperimentalFeatureWrapper extends StatelessWidget {
  const ExperimentalFeatureWrapper({
    required this.featureFlag,
    required this.onEnabled,
    this.onDisabled = _defaultOnDisabled,
    super.key,
  });

  final GenericFeatureFlag featureFlag;
  final Widget Function(BuildContext) onEnabled;
  final Widget Function(BuildContext) onDisabled;

  static Widget _defaultOnDisabled(BuildContext context) {
    return Container();
  }
  
  @override
  Widget build(BuildContext context) {
    return featureFlag.isEnabled() ? onEnabled(context) : onDisabled(context);
  }
}
