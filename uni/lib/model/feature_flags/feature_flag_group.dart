import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlagGroup extends GenericFeatureFlag {
  FeatureFlagGroup({
    required this.code,
    required this.name,
    required bool enabled,
    required void Function(FeatureFlagGroup, { required bool enabled }) saveEnabled,
  }): _enabled = enabled, _saveEnabled = saveEnabled;

  @override
  final String code;
  @override
  final String name;
  bool _enabled;
  final void Function(FeatureFlagGroup, { required bool enabled }) _saveEnabled;
  final List<FeatureFlag> _featureFlags = [];

  @override
  bool get enabled => _enabled;

  @override
  set enabled(bool enabled) {
    _saveEnabled(this, enabled: enabled);
    _enabled = enabled;
  }
  
  void addFeatureFlag(FeatureFlag featureFlag) {
    _featureFlags.add(featureFlag);
  }

  List<FeatureFlag> getFeatureFlags() {
    return _featureFlags;
  }
}
