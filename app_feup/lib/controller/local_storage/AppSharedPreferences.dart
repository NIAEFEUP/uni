import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
import 'package:tuple/tuple.dart';

class AppSharedPreferences {

  static final String userNumber = "user_number";
  static final String userPw = "user_password";
  static final int keyLength = 32;
  static final int ivLength = 16;

  static Future savePersistentUserInfo(user, pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userNumber, user);
    prefs.setString(userPw, encode(pass));
  }

  static Future removePersistentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userNumber);
    prefs.remove(userPw);
  }

  static Future<Tuple2<String, String>> getPersistentUserInfo() async {
    String user_num = await getUserNumber();
    String user_pass = await getUserPassword();
    return new Tuple2(user_num, user_pass);
  }

  static Future<String> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNumber) ?? ""; // empty string for the case it does not exist
  }

  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String pass = prefs.getString(userPw) ?? "";

    if (pass != "")
      pass = decode(pass);
    else print('User password does not exist in shared preferences.');

    return pass;
  }

  static String encode(String plainText) {
    final encrypter = _createEncrypter();
    return encrypter.encrypt(plainText).base64;
  }

  static String decode(String base64Text) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(base64Text);
  }

  static Encrypter _createEncrypter() {
    final key = Key.fromLength(keyLength);
    final iv = IV.fromLength(ivLength);
    return Encrypter(AES(key, iv));
  }
}
