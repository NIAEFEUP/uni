import 'dart:async';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/utils/favorite_widget_type.dart';

/// Manages the app's Shared Preferences.
///
/// This database stores the user's student number, password and favorite
/// widgets.
class PreferencesController {
  // TODO(bdmendes): Initilizate this also on workmanager
  static late SharedPreferences prefs;

  static final iv = encrypt.IV.fromBase64('jF9jjdSEPgsKnf0jCl1GAQ==');
  static final key =
      encrypt.Key.fromBase64('DT3/GTNYldhwOD3ZbpVLoAwA/mncsN7U7sJxfFn3y0A=');

  static const lastUpdateTimeKeySuffix = '_last_update_time';
  static const String userNumber = 'user_number';
  static const String userPw = 'user_password';
  static const String userFaculties = 'user_faculties';
  static const String termsAndConditions = 'terms_and_conditions';
  static const String areTermsAndConditionsAcceptedKey = 'is_t&c_accepted';
  static const String tuitionNotificationsToggleKey =
      'tuition_notification_toogle';
  static const String usageStatsToggleKey = 'usage_stats_toogle';
  static const String themeMode = 'theme_mode';
  static const String locale = 'app_locale';
  static const String favoriteCards = 'favorite_cards';
  static final List<FavoriteWidgetType> defaultFavoriteCards = [
    FavoriteWidgetType.schedule,
    FavoriteWidgetType.exams,
    FavoriteWidgetType.busStops,
  ];
  static const String hiddenExams = 'hidden_exams';
  static const String favoriteRestaurants = 'favorite_restaurants';
  static const String filteredExamsTypes = 'filtered_exam_types';
  static final List<String> defaultFilteredExamTypes = Exam.displayedTypes;

  /// Returns the last time the data with given key was updated.
  static DateTime? getLastDataClassUpdateTime(String dataKey) {
    final lastUpdateTime = prefs.getString(dataKey + lastUpdateTimeKeySuffix);
    return lastUpdateTime != null ? DateTime.parse(lastUpdateTime) : null;
  }

  /// Sets the last time the data with given key was updated.
  static Future<void> setLastDataClassUpdateTime(
    String dataKey,
    DateTime dateTime,
  ) async {
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
    await prefs.setBool(areTermsAndConditionsAcceptedKey, areAccepted);
  }

  /// Returns whether or not the Terms and Conditions have been accepted.
  static bool areTermsAndConditionsAccepted() {
    return prefs.getBool(areTermsAndConditionsAcceptedKey) ?? false;
  }

  /// Returns the hash of the last Terms and Conditions that have
  /// been accepted by the user.
  static String? getTermsAndConditionHash() {
    return prefs.getString(termsAndConditions);
  }

  /// Sets the hash of the Terms and Conditions that have been accepted
  /// by the user.
  static Future<bool> setTermsAndConditionHash(String hashed) async {
    return prefs.setString(termsAndConditions, hashed);
  }

  /// Gets current used theme mode.
  static ThemeMode getThemeMode() {
    return ThemeMode.values[prefs.getInt(themeMode) ?? ThemeMode.system.index];
  }

  /// Set new app theme mode.
  static Future<bool> setThemeMode(ThemeMode thmMode) async {
    return prefs.setInt(themeMode, thmMode.index);
  }

  /// Set app next theme mode.
  static Future<bool> setNextThemeMode() async {
    final themeIndex = getThemeMode().index;
    return prefs.setInt(themeMode, (themeIndex + 1) % 3);
  }

  static Future<void> setLocale(AppLocale appLocale) async {
    await prefs.setString(locale, appLocale.name);
  }

  static AppLocale getLocale() {
    final appLocale =
        prefs.getString(locale) ?? Platform.localeName.substring(0, 2);

    return AppLocale.values.firstWhere(
      (e) => e.toString() == 'AppLocale.$appLocale',
      orElse: () => AppLocale.en,
    );
  }

  /// Deletes the user's student number and password.
  static Future<void> removePersistentUserInfo() async {
    await prefs.remove(userNumber);
    await prefs.remove(userPw);
  }

  /// Returns a tuple containing the user's student number and password.
  ///
  /// *Note:*
  /// * the first element in the tuple is the user's student number.
  /// * the second element in the tuple is the user's password, in plain text
  /// format.
  static Tuple2<String, String>? getPersistentUserInfo() {
    final userNum = getUserNumber();
    final userPass = getUserPassword();
    if (userNum == null || userPass == null) {
      return null;
    }
    return Tuple2(userNum, userPass);
  }

  /// Returns the user's faculties
  static List<String> getUserFaculties() {
    final storedFaculties = prefs.getStringList(userFaculties);
    return storedFaculties ?? ['feup'];
    // TODO(bdmendes): Store dropdown choices in the db for later storage;
  }

  /// Returns the user's student number.
  static String? getUserNumber() {
    return prefs.getString(userNumber);
  }

  /// Returns the user's password, in plain text format.
  static String? getUserPassword() {
    final password = prefs.getString(userPw);
    return password != null ? decode(password) : null;
  }

  /// Replaces the user's favorite widgets with [newFavorites].
  static Future<void> saveFavoriteCards(
    List<FavoriteWidgetType> newFavorites,
  ) async {
    await prefs.setStringList(
      favoriteCards,
      newFavorites.map((a) => a.index.toString()).toList(),
    );
  }

  /// Returns a list containing the user's favorite widgets.
  static List<FavoriteWidgetType> getFavoriteCards() {
    final storedFavorites = prefs
        .getStringList(favoriteCards)
        ?.where(
          (element) => int.parse(element) < FavoriteWidgetType.values.length,
        )
        .toList();

    if (storedFavorites == null) {
      return defaultFavoriteCards;
    }

    return storedFavorites
        .map((i) => FavoriteWidgetType.values[int.parse(i)])
        .toList();
  }

  static Future<void> saveFavoriteRestaurants(
    List<String> newFavoriteRestaurants,
  ) async {
    await prefs.setStringList(favoriteRestaurants, newFavoriteRestaurants);
  }

  static List<String> getFavoriteRestaurants() {
    final storedFavoriteRestaurants =
        prefs.getStringList(favoriteRestaurants) ?? [];
    return storedFavoriteRestaurants;
  }

  static Future<void> saveHiddenExams(List<String> newHiddenExams) async {
    await prefs.setStringList(hiddenExams, newHiddenExams);
  }

  static List<String> getHiddenExams() {
    final storedHiddenExam = prefs.getStringList(hiddenExams) ?? [];
    return storedHiddenExam;
  }

  /// Replaces the user's exam filter settings with [newFilteredExamTypes].
  static Future<void> saveFilteredExams(
    Map<String, bool> newFilteredExamTypes,
  ) async {
    final newTypes = newFilteredExamTypes.keys
        .where((type) => newFilteredExamTypes[type] ?? false)
        .toList();
    await prefs.setStringList(filteredExamsTypes, newTypes);
  }

  /// Returns the user's exam filter settings.
  static Map<String, bool> getFilteredExams() {
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
  static String? decode(String base64Text) {
    final encrypter = _createEncrypter();
    try {
      return encrypter.decrypt64(base64Text, iv: iv);
    } catch (e) {
      return null;
    }
  }

  /// Creates an [encrypt.Encrypter] for encrypting and decrypting the user's
  /// password.
  static encrypt.Encrypter _createEncrypter() {
    return encrypt.Encrypter(encrypt.AES(key));
  }

  static bool getTuitionNotificationToggle() {
    return prefs.getBool(tuitionNotificationsToggleKey) ?? true;
  }

  static Future<void> setTuitionNotificationToggle({
    required bool value,
  }) async {
    await prefs.setBool(tuitionNotificationsToggleKey, value);
  }

  static bool getUsageStatsToggle() {
    return prefs.getBool(usageStatsToggleKey) ?? true;
  }

  static Future<void> setUsageStatsToggle({
    required bool value,
  }) async {
    await prefs.setBool(usageStatsToggleKey, value);
  }
}
