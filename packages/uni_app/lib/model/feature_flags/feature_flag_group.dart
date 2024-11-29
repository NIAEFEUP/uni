import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlagGroup extends GenericFeatureFlag {
  FeatureFlagGroup({
    required this.code,
    required String Function(BuildContext) getName,
    required bool Function() isEnabled,
    required Future<void> Function({required bool enabled}) saveEnabled,
    required List<FeatureFlag> featureFlags,
  })  : _getName = getName,
        _isEnabled = isEnabled,
        _saveEnabled = saveEnabled,
        _featureFlags = featureFlags;

  @override
  final String code;
  final String Function(BuildContext) _getName;
  final bool Function() _isEnabled;
  final Future<void> Function({required bool enabled}) _saveEnabled;
  final List<FeatureFlag> _featureFlags;

  @override
  String getName(BuildContext context) => _getName(context);

  @override
  bool isEnabled() => _isEnabled();

  @override
  Future<void> setEnabled({required bool enabled}) async {
    await _saveEnabled(enabled: enabled);

    for (final featureFlag in _featureFlags) {
      await featureFlag.setEnabled(enabled: enabled);
    }
  }

  List<FeatureFlag> getFeatureFlags() {
    return _featureFlags;
  }
}
