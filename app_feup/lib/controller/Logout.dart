import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/ActionCreators.dart';

import 'local_storage/AppCoursesDatabase.dart';
import 'local_storage/AppExamsDatabase.dart';
import 'local_storage/AppLecturesDatabase.dart';
import 'local_storage/AppRefreshTimesDatabase.dart';
import 'local_storage/AppUserDataDatabase.dart';

Future logout(BuildContext context) async {

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  (await AppLecturesDatabase()).deleteLectures();
  (await AppExamsDatabase()).deleteExams();
  (await AppCoursesDatabase()).deleteCourses();
  (await AppRefreshTimesDatabase()).deleteRefreshTimes();
  (await AppUserDataDatabase()).deleteUserData();

  StoreProvider.of<AppState>(context).dispatch(setInitialStoreState());
}
