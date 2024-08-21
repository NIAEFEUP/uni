import 'package:uni/controller/feature_flags/feature_flag_info.dart';
import 'package:uni/controller/feature_flags/feature_flag_state_controller.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/feature_flag_group.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlagController {
  static final List<GenericFeatureFlag> _featureFlags = []; // To preserve order
  static final Map<String, GenericFeatureFlag> _featureFlagsMap =
      {}; // For fast lookup
  static FeatureFlagStateController? _stateController;

  static void parseFeatureFlagTable(
    List<GenericFeatureFlagInfo> featureFlagInfos,
  ) {
    for (final featureFlagInfo in featureFlagInfos) {
      final featureFlag = featureFlagInfo is FeatureFlagInfo
          ? _createFeatureFlag(featureFlagInfo)
          : _createFeatureFlagGroup(featureFlagInfo as FeatureFlagGroupInfo);

      _featureFlags.add(featureFlag);
      _featureFlagsMap[featureFlag.code] = featureFlag;

      if (featureFlag is FeatureFlagGroup) {
        for (final subFeatureFlag in featureFlag.getFeatureFlags()) {
          _featureFlagsMap[subFeatureFlag.code] = subFeatureFlag;
        }
      }
    }
  }

  static bool _isEnabled(String code) {
    if (_stateController == null) {
      throw Exception('FeatureFlagStateController is not initialized.');
    }

    return _stateController!.isEnabled(code);
  }

  static Future<void> _saveEnabled(String code, {required bool enabled}) async {
    if (_stateController == null) {
      throw Exception('FeatureFlagStateController is not initialized.');
    }

    await _stateController!.saveEnabled(code, enabled: enabled);
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

  static GenericFeatureFlag _createFeatureFlagGroup(
    FeatureFlagGroupInfo featureFlagGroupInfo,
  ) {
    final code = featureFlagGroupInfo.code;
    final getName = featureFlagGroupInfo.getName;
    final featureFlags =
        featureFlagGroupInfo.featureFlags.map(_createFeatureFlag).toList();

    final featureFlagGroup = FeatureFlagGroup(
      code: code,
      getName: getName,
      isEnabled: () => _isEnabled(code),
      saveEnabled: ({required enabled}) => _saveEnabled(code, enabled: enabled),
      featureFlags: featureFlags,
    );

    return featureFlagGroup;
  }

  static GenericFeatureFlag? getFeatureFlag(String code) {
    return _featureFlagsMap[code];
  }

  static void setStateController(FeatureFlagStateController stateController) {
    _stateController = stateController;
  }

  static List<GenericFeatureFlag> getFeatureFlags() {
    return _featureFlags;
  }
}
