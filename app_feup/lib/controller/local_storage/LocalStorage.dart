import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future savePersistentUserInfo(user, pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_number', user);
    prefs.setString('user_pass', pass);
  }


  static Future removePersistentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_number', "");
    prefs.setString('user_pass', "");
  }
}
