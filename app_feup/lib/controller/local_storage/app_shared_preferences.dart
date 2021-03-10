import 'dart:async';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/home_page_model.dart';

//TODO Adicionar a databse exames filtrados
class AppSharedPreferences {
  static final String userNumber = 'user_number';
  static final String userPw = 'user_password';
  static final int keyLength = 32;
  static final int ivLength = 16;
  static final iv = IV.fromLength(ivLength);

  static final String favoriteCards = 'favorite_cards';
  static final List<FAVORITE_WIDGET_TYPE> defaultFavoriteCards = [
    FAVORITE_WIDGET_TYPE.schedule,
    FAVORITE_WIDGET_TYPE.exams,
    FAVORITE_WIDGET_TYPE.busStops
  ];
  //TODO
  static final String filteredExamsTypes = 'filtered_exam_types';
  static final List<String> defaultFilteredExamTypes =
      Exam.getExamTypes().keys.toList();

  static final String filteredExamsTypesChecked = 'filtered_exam_types_checked';
  static final List<String> defaultFilteredExamTypesChecked =
      Exam.getExamTypes().keys.toList();

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
    final String userNum = await getUserNumber();
    final String userPass = await getUserPassword();
    return Tuple2(userNum, userPass);
  }

  static Future<String> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNumber) ??
        ''; // empty string for the case it does not exist
  }

  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String pass = prefs.getString(userPw) ?? '';

    if (pass != '') {
      pass = decode(pass);
    } else {
      Logger().w('User password does not exist in shared preferences.');
    }

    return pass;
  }

  static saveFavoriteCards(List<FAVORITE_WIDGET_TYPE> newFavorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        favoriteCards, newFavorites.map((a) => a.index.toString()).toList());
  }

  static Future<List<FAVORITE_WIDGET_TYPE>> getFavoriteCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites = prefs.getStringList(favoriteCards);
    if (storedFavorites == null) return defaultFavoriteCards;
    return storedFavorites
            .map((i) => FAVORITE_WIDGET_TYPE.values[int.parse(i)])
            .toList() ??
        defaultFavoriteCards;
  }

  //TODO nao sei o que estou a fazer help
  static saveFilteredExams(Map<String, bool> newFilteredExamTypes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        filteredExamsTypesChecked, newFilteredExamTypes.keys.toList());
  }

  //TODO Aqui também não Verificar se o storedChecked pode estar a null
  static Future<Map<String, bool>> getFilteredExams() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFilteredExamTypes =
        prefs.getStringList(filteredExamsTypes);
    final List<String> storedFilteredExamTypesChecked =
        prefs.getStringList(filteredExamsTypesChecked);

    final Map<String, bool> examsfiltered = {};
    if (storedFilteredExamTypes == null || storedFilteredExamTypesChecked == null) {
      defaultFilteredExamTypes.forEach((type) => examsfiltered[type] = true);
      return examsfiltered;
    }

    for (String examType in storedFilteredExamTypes) {
      if (storedFilteredExamTypesChecked.contains(examType)) {
        examsfiltered[examType] = true;
      } else {
        examsfiltered[examType] = false;
      }
    }
    return examsfiltered;
  }

  static String encode(String plainText) {
    final encrypter = _createEncrypter();
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static String decode(String base64Text) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(base64Text, iv: iv);
  }

  static Encrypter _createEncrypter() {
    final key = Key.fromLength(keyLength);
    return Encrypter(AES(key));
  }
}
