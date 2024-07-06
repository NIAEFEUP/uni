import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlag extends GenericFeatureFlag {
  FeatureFlag({
    required this.code,
    required this.name,
    required bool enabled,
    required void Function(FeatureFlag, { required bool enabled }) saveEnabled,
  }): _enabled = enabled, _saveEnabled = saveEnabled;

  @override
  final String code;
  @override
  final String name;
  bool _enabled;
  final void Function(FeatureFlag, { required bool enabled }) _saveEnabled;

  @override
  bool get enabled => _enabled;

  @override
  set enabled(bool enabled) {
    _saveEnabled(this, enabled: enabled);
    _enabled = enabled;
  }
}
