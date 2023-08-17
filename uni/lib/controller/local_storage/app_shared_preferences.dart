import 'dart:async';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/utils/favorite_widget_type.dart';

/// Manages the app's Shared Preferences.
///
/// This database stores the user's student number, password and favorite
/// widgets.
class AppSharedPreferences {
  static const lastUpdateTimeKeySuffix = '_last_update_time';
  static const String userNumber = 'user_number';
  static const String userPw = 'user_password';
  static const String userFaculties = 'user_faculties';
  static const String termsAndConditions = 'terms_and_conditions';
  static const String areTermsAndConditionsAcceptedKey = 'is_t&c_accepted';
  static const String tuitionNotificationsToggleKey =
      'tuition_notification_toogle';
  static const String themeMode = 'theme_mode';
  static const int keyLength = 32;
  static const int ivLength = 16;
  static final iv = encrypt.IV.fromLength(ivLength);

  static const String favoriteCards = 'favorite_cards';
  static final List<FavoriteWidgetType> defaultFavoriteCards = [
    FavoriteWidgetType.schedule,
    FavoriteWidgetType.exams,
    FavoriteWidgetType.busStops
  ];
  static const String hiddenExams = 'hidden_exams';
  static const String filteredExamsTypes = 'filtered_exam_types';
  static final List<String> defaultFilteredExamTypes = Exam.displayedTypes;

  /// Returns the last time the data with given key was updated.
  static Future<DateTime?> getLastDataClassUpdateTime(String dataKey) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateTime = prefs.getString(dataKey + lastUpdateTimeKeySuffix);
    return lastUpdateTime != null ? DateTime.parse(lastUpdateTime) : null;
  }

  /// Sets the last time the data with given key was updated.
  static Future<void> setLastDataClassUpdateTime(
    String dataKey,
    DateTime dateTime,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      dataKey + lastUpdateTimeKeySuffix,
      dateTime.toString(),
    );
  }

  /// Saves the user's student number, password and faculties.
  static Future<void> savePersistentUserInfo(
    String user,
    String pass,
    List<String> faculties,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNumber, user);
    await prefs.setString(userPw, encode(pass));
    await prefs.setStringList(
      userFaculties,
      faculties,
    ); // Could be multiple faculties
  }

  /// Sets whether or not the Terms and Conditions have been accepted.
  static Future<void> setTermsAndConditionsAcceptance({
    required bool areAccepted,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(areTermsAndConditionsAcceptedKey, areAccepted);
  }

  /// Returns whether or not the Terms and Conditions have been accepted.
  static Future<bool> areTermsAndConditionsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(areTermsAndConditionsAcceptedKey) ?? false;
  }

  /// Returns the hash of the last Terms and Conditions that have
  /// been accepted by the user.
  static Future<String?> getTermsAndConditionHash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(termsAndConditions);
  }

  /// Sets the hash of the Terms and Conditions that have been accepted
  /// by the user.
  static Future<bool> setTermsAndConditionHash(String hashed) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(termsAndConditions, hashed);
  }

  /// Gets current used theme mode.
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeMode.values[prefs.getInt(themeMode) ?? ThemeMode.system.index];
  }

  /// Set new app theme mode.
  static Future<bool> setThemeMode(ThemeMode thmMode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(themeMode, thmMode.index);
  }

  /// Set app next theme mode.
  static Future<bool> setNextThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = (await getThemeMode()).index;
    return prefs.setInt(themeMode, (themeIndex + 1) % 3);
  }

  /// Deletes the user's student number and password.
  static Future<void> removePersistentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNumber);
    await prefs.remove(userPw);
  }

  /// Returns a tuple containing the user's student number and password.
  ///
  /// *Note:*
  /// * the first element in the tuple is the user's student number.
  /// * the second element in the tuple is the user's password, in plain text
  /// format.
  static Future<Tuple2<String, String>> getPersistentUserInfo() async {
    final userNum = await getUserNumber();
    final userPass = await getUserPassword();
    return Tuple2(userNum, userPass);
  }

  /// Returns the user's faculties
  static Future<List<String>> getUserFaculties() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFaculties = prefs.getStringList(userFaculties);
    return storedFaculties ?? ['feup'];
    // TODO(bdmendes): Store dropdown choices in the db for later storage;
  }

  /// Returns the user's student number.
  static Future<String> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNumber) ??
        ''; // empty string for the case it does not exist
  }

  /// Returns the user's password, in plain text format.
  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    var pass = prefs.getString(userPw) ?? '';

    if (pass != '') {
      pass = decode(pass);
    }

    return pass;
  }

  /// Replaces the user's favorite widgets with [newFavorites].
  static Future<void> saveFavoriteCards(
    List<FavoriteWidgetType> newFavorites,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      favoriteCards,
      newFavorites.map((a) => a.index.toString()).toList(),
    );
  }

  /// Returns a list containing the user's favorite widgets.
  static Future<List<FavoriteWidgetType>> getFavoriteCards() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList(favoriteCards);
    if (storedFavorites == null) return defaultFavoriteCards;
    return storedFavorites
        .map((i) => FavoriteWidgetType.values[int.parse(i)])
        .toList();
  }

  static Future<void> saveHiddenExams(List<String> newHiddenExams) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(hiddenExams, newHiddenExams);
  }

  static Future<List<String>> getHiddenExams() async {
    final prefs = await SharedPreferences.getInstance();
    final storedHiddenExam = prefs.getStringList(hiddenExams) ?? [];
    return storedHiddenExam;
  }

  /// Replaces the user's exam filter settings with [newFilteredExamTypes].
  static Future<void> saveFilteredExams(
    Map<String, bool> newFilteredExamTypes,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final newTypes = newFilteredExamTypes.keys
        .where((type) => newFilteredExamTypes[type] ?? false)
        .toList();
    await prefs.setStringList(filteredExamsTypes, newTypes);
  }

  /// Returns the user's exam filter settings.
  static Future<Map<String, bool>> getFilteredExams() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFilteredExamTypes = prefs.getStringList(filteredExamsTypes);

    if (storedFilteredExamTypes == null) {
      return Map.fromIterable(defaultFilteredExamTypes, value: (type) => true);
    }
    return Map.fromIterable(
      defaultFilteredExamTypes,
      value: storedFilteredExamTypes.contains,
    );
  }

  /// Encrypts [plainText] and returns its base64 representation.
  static String encode(String plainText) {
    final encrypter = _createEncrypter();
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  /// Decrypts [base64Text].
  static String decode(String base64Text) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(base64Text, iv: iv);
  }

  /// Creates an [encrypt.Encrypter] for encrypting and decrypting the user's
  /// password.
  static encrypt.Encrypter _createEncrypter() {
    final key = encrypt.Key.fromLength(keyLength);
    return encrypt.Encrypter(encrypt.AES(key));
  }

  static Future<bool> getTuitionNotificationToggle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tuitionNotificationsToggleKey) ?? true;
  }

  static Future<void> setTuitionNotificationToggle({
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tuitionNotificationsToggleKey, value);
  }
}
