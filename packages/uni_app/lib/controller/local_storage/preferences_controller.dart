import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/favorite_widget_type.dart';

/// Manages the app's Shared Preferences.
///
/// This database stores the user's student number, password and favorite
/// widgets.
class PreferencesController {
  static late SharedPreferences prefs;

  static const String _version = 'preferences_version';
  static const _lastUpdateTimeKeySuffix = '_last_update_time';
  static const String _userSession = 'user_session';
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
  static final List<FavoriteWidgetType> _homeDefaultcards = [
    FavoriteWidgetType.schedule,
    FavoriteWidgetType.exams,
  ];
  static const String _hiddenExams = 'hidden_exams';
  static const String _favoriteRestaurants = 'favorite_restaurants';
  static const String _filteredExamsTypes = 'filtered_exam_types';
  static final List<String> _defaultFilteredExamTypes = Exam.displayedTypes;
  static const String _semesterValue = 'semester_value';
  static const String _schoolYearValue = 'school_year_value';
  static const String _serviceCardsIsGrid = 'service_cards_is_grid';
  static const String _selectedDishType = 'selected_dish_type';
  static const String _selectedDishTypes = 'selected_dish_types';
  static final Set<String> _defaultSelectedDishes = {
    'meat_dishes',
    'fish_dishes',
    'vegetarian_dishes',
    'soups',
    'salads',
    'diet_dishes',
    'dishes_of_the_day',
  };
  static const String _isFavoriteRestaurantsFilterOn =
      'is_favorite_restaurant_filter_on';
  static const String _selectedCampusFilter = 'selected_campus';
  static const String _isRestaurantReminderDismissed =
      'is_restaurant_reminder_dismissed';

  static final _statsToggleStreamController =
      StreamController<bool>.broadcast();
  static final onStatsToggle = _statsToggleStreamController.stream;

  static final _hiddenExamsChangeStreamController =
      StreamController<List<String>>.broadcast();
  static final onHiddenExamsChange = _hiddenExamsChangeStreamController.stream;

  static int getPreferencesVersion() {
    return prefs.getInt(_version) ?? 1;
  }

  static Future<bool> setPreferencesVersion(int newVersion) async {
    return prefs.setInt(_version, newVersion);
  }

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
  static Future<void> saveSession(
    Session session,
  ) async {
    await _secureStorage.write(
      key: _userSession,
      value: jsonEncode(session.toJson()),
    );
  }

  static Future<Session?> getSavedSession() async {
    final value = await _secureStorage.read(key: _userSession);
    if (value == null) {
      return null;
    }

    final json = jsonDecode(value) as Map<String, dynamic>;
    return Session.fromJson(json);
  }

  static Future<bool> isSessionPersistent() async {
    return _secureStorage.containsKey(key: _userSession);
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

  static Future<void> removeSavedSession() async {
    await _secureStorage.delete(key: _userSession);
  }

  static Future<void> setDefaultCards() async {
    await prefs.setStringList(
      _favoriteCards,
      _homeDefaultcards.map((elem) => elem.name).toList(),
    );
  }

  static Future<void> saveFavoriteCards(
    List<FavoriteWidgetType> newFavorites,
  ) async {
    await prefs.setStringList(
      _favoriteCards,
      newFavorites
          .fold(<FavoriteWidgetType>[], (toStore, widgetType) {
            if (!toStore.contains(widgetType)) {
              toStore.add(widgetType);
            }

            return toStore;
          })
          .map((elem) => elem.name)
          .toList(),
    );
  }

  static List<FavoriteWidgetType> getFavoriteCards() {
    final storedFavorites = prefs.getStringList(_favoriteCards);

    if (storedFavorites == null) {
      return _homeDefaultcards;
    }

    return storedFavorites
        .map(
          (elem) => FavoriteWidgetType.values.firstWhere((e) => e.name == elem),
        )
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

  static Future<void> setSemesterValue(String? value) async {
    await prefs.setString(_semesterValue, value ?? '');
    if (value == null) {
      await prefs.remove(_semesterValue);
    }
  }

  static String? getSemesterValue() {
    return prefs.getString(_semesterValue);
  }

  static Future<void> setSchoolYearValue(String? value) async {
    await prefs.setString(_schoolYearValue, value ?? '');
    if (value == null) {
      await prefs.remove(_schoolYearValue);
    }
  }

  static String? getSchoolYearValue() {
    return prefs.getString(_schoolYearValue);
  }

  static Future<void> setServiceCardsIsGrid(bool value) async {
    await prefs.setBool(_serviceCardsIsGrid, value);
  }

  static bool getServiceCardsIsGrid() {
    return prefs.getBool(_serviceCardsIsGrid) ?? true;
  }

  static Future<void> setSelectedDishTypes(Set<String> values) async {
    await prefs.setStringList(
      _selectedDishTypes,
      values.toList(),
    );
  }

  static Set<String> getSelectedDishTypes() {
    final stored = prefs.getStringList(_selectedDishTypes);
    if (stored == null) {
      return _defaultSelectedDishes;
    }
    return stored.toSet();
  }

  static Future<void> setIsFavoriteRestaurantsFilterOn(bool? value) async {
    await prefs.setBool(_isFavoriteRestaurantsFilterOn, value ?? false);
    if (value == null) {
      await prefs.remove(_selectedDishType);
    }
  }

  static bool? getIsFavoriteRestaurantsFilterOn() {
    return prefs.getBool(_isFavoriteRestaurantsFilterOn);
  }

  static Future<void> setSelectedCampus(int value) async {
    await prefs.setInt(_selectedCampusFilter, value);
  }

  static int? getSelectedCampus() {
    return prefs.getInt(_selectedCampusFilter);
  }

  static Future<void> setRestaurantReminderDismissed(bool isDismissed) async {
    await prefs.setBool(_isRestaurantReminderDismissed, isDismissed);
  }

  static bool isRestaurantReminderDismissed() {
    return prefs.getBool(_isRestaurantReminderDismissed) ?? false;
  }
}
