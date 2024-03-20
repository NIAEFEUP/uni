import 'package:shared_preferences/shared_preferences.dart';

class EnabledFeatureController {
  EnabledFeatureController(this.preferences);

  final SharedPreferences preferences;
  static const String _preferenceKey = 'features';

  Future<void> addFeature(String feature) async {
    final features = preferences.getStringList(_preferenceKey) ?? <String>[];
    if (!features.contains(feature)) {
      features.add(feature);
    }
    await preferences.setStringList(_preferenceKey, features);
  }

  Future<void> removeFeature(String feature) async {
    final features = (preferences.getStringList(_preferenceKey) ?? <String>[])
      ..remove(feature);
    await preferences.setStringList(_preferenceKey, features);
  }

  bool existsFeature(String feature) {
    final features = preferences.getStringList(_preferenceKey);
    return features != null && features.contains(feature);
  }
}
