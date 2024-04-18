import 'dart:async';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  static late SharedPreferences prefs;

  static final iv = encrypt.IV.fromBase64('jF9jjdSEPgsKnf0jCl1GAQ==');
  static final key =
      encrypt.Key.fromBase64('DT3/GTNYldhwOD3ZbpVLoAwA/mncsN7U7sJxfFn3y0A=');

  static const _lastUpdateTimeKeySuffix = '_last_update_time';
  static const String _userNumber = 'user_number';
  static const String _userPw = 'user_password';
  static const String _userFaculties = 'user_faculties';
  static const String _termsAndConditions = 'terms_and_conditions';
  static const String _areTermsAndConditionsAcceptedKey = 'is_t&c_accepted';
  static const String _tuitionNotificationsToggleKey =
      'tuition_notification_toogle';
  static const String _usageStatsToggleKey = 'usage_stats_toogle';
  static const String _themeMode = 'theme_mode';
  static const String _isDataCollectionBannerViewedKey =
      'data_collection_banner';
  static const String _locale = 'app_locale';
  static const String _lastCacheCleanUpDate = 'last_clean';
  static const String _favoriteCards = 'favorite_cards';
  static final List<FavoriteWidgetType> _defaultFavoriteCards = [
    FavoriteWidgetType.schedule,
    FavoriteWidgetType.exams,
    FavoriteWidgetType.busStops,
  ];
  static const String _hiddenExams = 'hidden_exams';
  static const String _favoriteRestaurants = 'favorite_restaurants';
  static const String _filteredExamsTypes = 'filtered_exam_types';
  static final List<String> _defaultFilteredExamTypes = Exam.displayedTypes;

  static final _statsToggleStreamController =
      StreamController<bool>.broadcast();
  static final onStatsToggle = _statsToggleStreamController.stream;

  static final _hiddenExamsChangeStreamController =
      StreamController<List<String>>.broadcast();
  static final onHiddenExamsChange = _hiddenExamsChangeStreamController.stream;

  /// Returns the last time the data with given key was updated.
  static DateTime? getLastDataClassUpdateTime(String dataKey) {
    final lastUpdateTime = prefs.getString(dataKey + _lastUpdateTimeKeySuffix);
    return lastUpdateTime != null ? DateTime.parse(lastUpdateTime) : null;
  }

  /// Sets the last time the data with given key was updated.
  static Future<void> setLastDataClassUpdateTime(
    String dataKey,
    DateTime dateTime,
  ) async {
    await prefs.setString(
      dataKey + _lastUpdateTimeKeySuffix,
      dateTime.toString(),
    );
  }

  /// Saves the user's student number, password and faculties.
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static Future<void> savePersistentUserInfo(
    String user,
    String pass,
    List<String> faculties,
  ) async {
    await _secureStorage.write(key: _userNumber, value: user);
    await _secureStorage.write(key: _userPw, value: pass);
    await prefs.setStringList(
      _userFaculties,
      faculties,
    ); // Could be multiple faculties;
  }

  /// Sets whether or not the Terms and Conditions have been accepted.
  static Future<void> setTermsAndConditionsAcceptance({
    required bool areAccepted,
  }) async {
    await prefs.setBool(_areTermsAndConditionsAcceptedKey, areAccepted);
  }

  /// Returns whether or not the Terms and Conditions have been accepted.
  static bool areTermsAndConditionsAccepted() {
    return prefs.getBool(_areTermsAndConditionsAcceptedKey) ?? false;
  }

  static Future<void> setDataCollectionBannerViewed({
    required bool isViewed,
  }) async {
    await prefs.setBool(_isDataCollectionBannerViewedKey, isViewed);
  }

  static bool isDataCollectionBannerViewed() {
    return prefs.getBool(_isDataCollectionBannerViewedKey) ?? false;
  }

  /// Returns the hash of the last Terms and Conditions that have
  /// been accepted by the user.
  static String? getTermsAndConditionHash() {
    return prefs.getString(_termsAndConditions);
  }

  /// Sets the hash of the Terms and Conditions that have been accepted
  /// by the user.
  static Future<bool> setTermsAndConditionHash(String hashed) async {
    return prefs.setString(_termsAndConditions, hashed);
  }

  /// Gets current used theme mode.
  static ThemeMode getThemeMode() {
    return ThemeMode.values[prefs.getInt(_themeMode) ?? ThemeMode.system.index];
  }

  /// Set new app theme mode.
  static Future<bool> setThemeMode(ThemeMode thmMode) async {
    return prefs.setInt(_themeMode, thmMode.index);
  }

  /// Set app next theme mode.
  static Future<bool> setNextThemeMode() async {
    final themeIndex = getThemeMode().index;
    return prefs.setInt(_themeMode, (themeIndex + 1) % 3);
  }

  static Future<void> setLocale(AppLocale appLocale) async {
    await prefs.setString(_locale, appLocale.name);
  }

  static AppLocale getLocale() {
    final appLocale =
        prefs.getString(_locale) ?? Platform.localeName.substring(0, 2);

    return AppLocale.values.firstWhere(
      (e) => e.toString() == 'AppLocale.$appLocale',
      orElse: () => AppLocale.en,
    );
  }

  static Future<void> setLastCleanUpDate(DateTime date) async {
    await prefs.setString(_lastCacheCleanUpDate, date.toString());
  }

  static DateTime getLastCleanUpDate() {
    final date =
        prefs.getString(_lastCacheCleanUpDate) ?? DateTime.now().toString();
    return DateTime.parse(date);
  }

  /// Deletes the user's student number and password.
  static Future<void> removePersistentUserInfo() async {
    await prefs.remove(_userNumber);
    await prefs.remove(_userPw);
  }

  /// Returns a tuple containing the user's student number and password.
  ///
  /// *Note:*
  /// * the first element in the tuple is the user's student number.
  /// * the second element in the tuple is the user's password, in plain text
  /// format.
  static Future<Tuple2<String, String>?> getPersistentUserInfo() async {
    final userNum = await getUserNumber();
    final userPass = await getUserPassword();
    if (userNum == null || userPass == null) {
      return null;
    }
    return Tuple2(userNum, userPass);
  }

  /// Returns the user's faculties
  static List<String> getUserFaculties() {
    final storedFaculties = prefs.getStringList(_userFaculties);
    return storedFaculties ?? ['feup'];
    // TODO(bdmendes): Store dropdown choices in the db for later storage;
  }

  /// Returns the user's student number.
  static Future<String?> getUserNumber() {
    return _secureStorage.read(key: _userNumber);
  }

  /// Returns the user's password, in plain text format.
  static Future<String?> getUserPassword() async {
    final password = await _secureStorage.read(key: _userPw);
    return password != null ? decode(password) : null;
  }

  /// Replaces the user's favorite widgets with [newFavorites].
  static Future<void> saveFavoriteCards(
    List<FavoriteWidgetType> newFavorites,
  ) async {
    await prefs.setStringList(
      _favoriteCards,
      newFavorites.map((a) => a.index.toString()).toList(),
    );
  }

  /// Returns a list containing the user's favorite widgets.
  static List<FavoriteWidgetType> getFavoriteCards() {
    final storedFavorites = prefs
        .getStringList(_favoriteCards)
        ?.where(
          (element) => int.parse(element) < FavoriteWidgetType.values.length,
        )
        .toList();

    if (storedFavorites == null) {
      return _defaultFavoriteCards;
    }

    return storedFavorites
        .map((i) => FavoriteWidgetType.values[int.parse(i)])
        .toList();
  }

  static Future<void> saveFavoriteRestaurants(
    List<String> newFavoriteRestaurants,
  ) async {
    await prefs.setStringList(_favoriteRestaurants, newFavoriteRestaurants);
  }

  static List<String> getFavoriteRestaurants() {
    final storedFavoriteRestaurants =
        prefs.getStringList(_favoriteRestaurants) ?? [];
    return storedFavoriteRestaurants;
  }

  static Future<void> saveHiddenExams(List<String> newHiddenExams) async {
    await prefs.setStringList(_hiddenExams, newHiddenExams);
    _hiddenExamsChangeStreamController.add(newHiddenExams);
  }

  static List<String> getHiddenExams() {
    final storedHiddenExam = prefs.getStringList(_hiddenExams) ?? [];
    return storedHiddenExam;
  }

  /// Replaces the user's exam filter settings with [newFilteredExamTypes].
  static Future<void> saveFilteredExams(
    Map<String, bool> newFilteredExamTypes,
  ) async {
    final newTypes = newFilteredExamTypes.keys
        .where((type) => newFilteredExamTypes[type] ?? false)
        .toList();
    await prefs.setStringList(_filteredExamsTypes, newTypes);
  }

  /// Returns the user's exam filter settings.
  static Map<String, bool> getFilteredExams() {
    final storedFilteredExamTypes = prefs.getStringList(_filteredExamsTypes);

    if (storedFilteredExamTypes == null) {
      return Map.fromIterable(_defaultFilteredExamTypes, value: (type) => true);
    }
    return Map.fromIterable(
      _defaultFilteredExamTypes,
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
    return prefs.getBool(_tuitionNotificationsToggleKey) ?? true;
  }

  static Future<void> setTuitionNotificationToggle({
    required bool value,
  }) async {
    await prefs.setBool(_tuitionNotificationsToggleKey, value);
  }

  static bool getUsageStatsToggle() {
    return prefs.getBool(_usageStatsToggleKey) ?? true;
  }

  static Future<void> setUsageStatsToggle({
    required bool value,
  }) async {
    await prefs.setBool(_usageStatsToggleKey, value);
    _statsToggleStreamController.add(value);
  }
}
