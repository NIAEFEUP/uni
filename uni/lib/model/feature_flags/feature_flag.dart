import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlag extends GenericFeatureFlag {
  FeatureFlag({
    required this.code,
    required String name,
    required bool enabled,
    required void Function({ required bool enabled }) saveEnabled,
  }): _name = name, _enabled = enabled, _saveEnabled = saveEnabled;

  @override
  final String code;
  String _name;
  bool _enabled;
  final void Function({ required bool enabled }) _saveEnabled;

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
  }

  @override
  bool get enabled => _enabled;

  @override
  set enabled(bool enabled) {
    _saveEnabled(enabled: enabled);
    _enabled = enabled;
  }
}
