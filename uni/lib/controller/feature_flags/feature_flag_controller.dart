import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlagController {
  FeatureFlagController(this.preferences): _featureFlags = _loadFromPreferences(preferences);

  final SharedPreferences preferences;
  final Map<String, bool> _featureFlags;
  static const _flagPrefix = '__feature_flag__';

  static Map<String, bool> _loadFromPreferences(SharedPreferences preferences) {
    return Map.fromIterable(preferences.getKeys()
      .where((key) => key.startsWith(_flagPrefix))
      .map((key) {
        final flagName = key.substring(_flagPrefix.length);
        return { flagName, preferences.getBool(key) ?? false};
      }),
    );
  }

  bool isFeatureEnabled(String featureName) {
    return _featureFlags[featureName] ?? false;
  }

  void setFeatureFlag(String featureName, { required bool enabled }) {
    _featureFlags[featureName] = enabled;

    final key = '$_flagPrefix$featureName';
    preferences.setBool(key, enabled);
  }
}
