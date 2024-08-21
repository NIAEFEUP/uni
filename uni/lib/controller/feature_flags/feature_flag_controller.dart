import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlagController {
  FeatureFlagController(this.preferences);

  final SharedPreferences preferences;
  static const _flagPrefix = '__feature_flag__';

  String _getKey(String code) => '$_flagPrefix$code';

  bool isEnabled(String code) {
    return preferences.getBool(_getKey(code)) ?? false;
  }

  void saveEnabled(String code, { required bool enabled }) {
    preferences.setBool(_getKey(code), enabled);
  }
}
