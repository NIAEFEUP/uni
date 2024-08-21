import 'package:uni/controller/feature_flags/feature_flag_controller.dart';
import 'package:uni/controller/feature_flags/feature_flag_info.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/feature_flag_group.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

List<GenericFeatureFlagInfo> featureFlagInfos = [
  FeatureFlagInfo(
    code: 'library_modules',
    getName: (context) => S.of(context).library_modules,
  ),
];

class FeatureFlagTable {
  static final List<GenericFeatureFlag> _featureFlags = _toFeatureFlags(featureFlagInfos);            // To preserve order
  static final Map<String, GenericFeatureFlag> _featureFlagsMap = _toFeatureFlagsMap(_featureFlags);  // For fast lookup
  static FeatureFlagController? _controller;

  static List<GenericFeatureFlag> _toFeatureFlags(List<GenericFeatureFlagInfo> featureFlagInfos) {
    final featureFlags = <GenericFeatureFlag>[];

    for (final featureFlagInfo in featureFlagInfos) {
      final featureFlag = featureFlagInfo is FeatureFlagInfo
          ? _createFeatureFlag(featureFlagInfo)
          : _createFeatureFlagGroup(featureFlagInfo as FeatureFlagGroupInfo);

      featureFlags.add(featureFlag);
    }

    return featureFlags;
  }

  static Map<String, GenericFeatureFlag> _toFeatureFlagsMap(List<GenericFeatureFlag> featureFlags) {
    final featureFlagsMap = <String, GenericFeatureFlag>{};

    for (final featureFlag in featureFlags) {
      featureFlagsMap[featureFlag.code] = featureFlag;
    }

    return featureFlagsMap;
  }

  static bool _isEnabled(String code) {
    if (_controller == null) {
      throw Exception('FeatureFlagController is not initialized.');
    }

    return _controller!.isEnabled(code);
  }

  static void _saveEnabled(String code, {required bool enabled}) {
    if (_controller == null) {
      throw Exception('FeatureFlagController is not initialized.');
    }

    _controller!.saveEnabled(code, enabled: enabled);
  }

  static FeatureFlag _createFeatureFlag(FeatureFlagInfo featureFlagInfo) {
    final code = featureFlagInfo.code;
    final getName = featureFlagInfo.getName;

    return FeatureFlag(
      code: code,
      getName: getName,
      isEnabled: () => _isEnabled(code),
      saveEnabled: ({required enabled}) => _saveEnabled(code, enabled: enabled),
    );
  }

  static GenericFeatureFlag _createFeatureFlagGroup(FeatureFlagGroupInfo featureFlagGroupInfo) {
    final code = featureFlagGroupInfo.code;
    final getName = featureFlagGroupInfo.getName;
    final featureFlags = featureFlagGroupInfo.featureFlags.map(_createFeatureFlag).toList();

    final featureFlagGroup = FeatureFlagGroup(
      code: code,
      getName: getName,
      isEnabled: () => _isEnabled(code),
      saveEnabled: ({required enabled}) {
        _saveEnabled(code, enabled: enabled);
        for (final featureFlag in featureFlags) {
          featureFlag.enabled = enabled;
        }
      },
      featureFlags: featureFlags,
    );

    return featureFlagGroup;
  }

  static GenericFeatureFlag? getFeatureFlag(String code) {
    return _featureFlagsMap[code];
  }

  static void setController(FeatureFlagController featureFlagController) {
    _controller = featureFlagController;
  }

  static List<GenericFeatureFlag> getFeatureFlags() {
    return _featureFlags;
  }
}
