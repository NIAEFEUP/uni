import 'package:flutter/material.dart';
import 'package:uni/controller/feature_flags/feature_flag_info.dart';
import 'package:uni/controller/feature_flags/feature_flag_state_controller.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/feature_flag_group.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlagController extends ChangeNotifier {
  FeatureFlagController({
    required FeatureFlagStateController stateController,
    required List<GenericFeatureFlagInfo> featureFlagInfos,
  }) : this._(
          parsedFeatureFlags:
              _parseFeatureFlagTable(stateController, featureFlagInfos),
        );

  FeatureFlagController._({
    required (
      List<GenericFeatureFlag>,
      Map<String, GenericFeatureFlag>
    ) parsedFeatureFlags,
  })  : _featureFlags = parsedFeatureFlags.$1,
        _featureFlagsMap = parsedFeatureFlags.$2;

  final List<GenericFeatureFlag> _featureFlags; // To preserve order
  final Map<String, GenericFeatureFlag> _featureFlagsMap; // For fast lookup

  static (List<GenericFeatureFlag>, Map<String, GenericFeatureFlag>)
      _parseFeatureFlagTable(
    FeatureFlagStateController stateController,
    List<GenericFeatureFlagInfo> featureFlagInfos,
  ) {
    final featureFlags = <GenericFeatureFlag>[];
    final featureFlagsMap = <String, GenericFeatureFlag>{};

    for (final featureFlagInfo in featureFlagInfos) {
      final featureFlag = featureFlagInfo is FeatureFlagInfo
          ? _createFeatureFlag(stateController, featureFlagInfo)
          : _createFeatureFlagGroup(
              stateController,
              featureFlagInfo as FeatureFlagGroupInfo,
            );

      featureFlags.add(featureFlag);
      featureFlagsMap[featureFlag.code] = featureFlag;

      if (featureFlag is FeatureFlagGroup) {
        for (final subFeatureFlag in featureFlag.getFeatureFlags()) {
          featureFlagsMap[subFeatureFlag.code] = subFeatureFlag;
        }
      }
    }

    return (featureFlags, featureFlagsMap);
  }

  static bool _isEnabled(
    FeatureFlagStateController stateController,
    String code,
  ) {
    return stateController.isEnabled(code);
  }

  static Future<void> _saveEnabled(
    FeatureFlagStateController stateController,
    String code, {
    required bool enabled,
  }) async {
    await stateController.saveEnabled(code, enabled: enabled);
  }

  static FeatureFlag _createFeatureFlag(
    FeatureFlagStateController stateController,
    FeatureFlagInfo featureFlagInfo,
  ) {
    final code = featureFlagInfo.code;
    final getName = featureFlagInfo.getName;

    return FeatureFlag(
      code: code,
      getName: getName,
      isEnabled: () => _isEnabled(stateController, code),
      saveEnabled: ({required enabled}) =>
          _saveEnabled(stateController, code, enabled: enabled),
    );
  }

  static GenericFeatureFlag _createFeatureFlagGroup(
    FeatureFlagStateController stateController,
    FeatureFlagGroupInfo featureFlagGroupInfo,
  ) {
    final code = featureFlagGroupInfo.code;
    final getName = featureFlagGroupInfo.getName;
    final featureFlags = featureFlagGroupInfo.featureFlags
        .map((info) => _createFeatureFlag(stateController, info))
        .toList();

    final featureFlagGroup = FeatureFlagGroup(
      code: code,
      getName: getName,
      isEnabled: () => _isEnabled(stateController, code),
      saveEnabled: ({required enabled}) =>
          _saveEnabled(stateController, code, enabled: enabled),
      featureFlags: featureFlags,
    );

    return featureFlagGroup;
  }

  GenericFeatureFlag? getFeatureFlag(String code) {
    return _featureFlagsMap[code];
  }

  List<GenericFeatureFlag> getFeatureFlags() {
    return _featureFlags;
  }
}
