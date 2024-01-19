import 'package:shared_preferences/shared_preferences.dart';

class EnabledFeatureController {
  EnabledFeatureController(this.preferences);

  final SharedPreferences preferences;
  static const String _preferenceKey = 'features';

  Future<void> saveEnabledFeatures(List<String> features) async {
      await preferences.setStringList(_preferenceKey, features);
  }

  List<String>? getEnabledFeatures() {
    return preferences.getStringList(_preferenceKey);
  }
}