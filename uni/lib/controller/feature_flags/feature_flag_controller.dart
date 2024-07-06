import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/model/feature_flags/feature_flag.dart';

class FeatureFlagController {
  FeatureFlagController(this.preferences);

  final SharedPreferences preferences;
  final _featureFlags = <FeatureFlag>[];
  static const _flagPrefix = '__feature_flag__';

  void _saveEnabled(FeatureFlag featureFlag, { required bool enabled }) {
    final key = '$_flagPrefix${featureFlag.code}';
    preferences.setBool(key, enabled);
  }

  FeatureFlag createFeatureFlag({ required String code, required String name }) {
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
      name: name,
      enabled: enabled,
      saveEnabled: _saveEnabled,
    );
    _featureFlags.add(featureFlag);
    return featureFlag;
  }
}
