class FeatureFlag {
  FeatureFlag({
    required this.code,
    required this.name,
    required bool enabled,
    required void Function(FeatureFlag, {required bool enabled}) saveEnabled,
  })  : _enabled = enabled,
        _saveEnabled = saveEnabled;

  final String code;
  final String name;
  bool _enabled;
  final void Function(FeatureFlag, {required bool enabled}) _saveEnabled;

  bool get enabled => _enabled;

  set enabled(bool enabled) {
    _saveEnabled(this, enabled: enabled);
    _enabled = enabled;
  }
}
