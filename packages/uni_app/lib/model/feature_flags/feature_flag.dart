import 'package:flutter/material.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlag extends GenericFeatureFlag {
  FeatureFlag({
    required this.code,
    required String Function(BuildContext) getName,
    required bool Function() isEnabled,
    required Future<void> Function({required bool enabled}) saveEnabled,
  })  : _getName = getName,
        _isEnabled = isEnabled,
        _saveEnabled = saveEnabled;

  @override
  final String code;
  final String Function(BuildContext) _getName;
  final bool Function() _isEnabled;
  final Future<void> Function({required bool enabled}) _saveEnabled;

  @override
  String getName(BuildContext context) => _getName(context);

  @override
  bool isEnabled() => _isEnabled();

  @override
  Future<void> setEnabled({required bool enabled}) =>
      _saveEnabled(enabled: enabled);
}
