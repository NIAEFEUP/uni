import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';
import 'package:uni/model/feature_flags/generic_feature_flag.dart';

class FeatureFlagController {
  FeatureFlagController(this.preferences);

  final SharedPreferences preferences;
  final Map<String, GenericFeatureFlag> _featureFlags = {};
  static const _flagPrefix = '__feature_flag__';

  FeatureFlag getFeatureFlag(String code) {
    if (_featureFlags.containsKey(code)) {
      final featureFlag = _featureFlags[code]!;
      if (featureFlag is! FeatureFlag) {
        throw Exception('Feature flag code does not match a FeatureFlag instance.');
      }
      return featureFlag;
    }

    final key = '$_flagPrefix$code';
    final bool enabled;
    if (!preferences.containsKey(key)) {
      preferences.setBool(key, false);
      enabled = false;
    } else {
      enabled = preferences.getBool(key)!;
    }

    final featureFlag = FeatureFlag(
      code: code,
      name: code,
      enabled: enabled,
      saveEnabled: ({ required enabled }) => preferences.setBool(key, enabled),
    );
    _featureFlags[featureFlag.code] = featureFlag;
    return featureFlag;
  }
}
