import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/ActionCreators.dart';

Future logout(BuildContext context) async {

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  AppDatabase.removeDatabase('exams.db');
  AppDatabase.removeDatabase('lectures.db');

  StoreProvider.of<AppState>(context).dispatch(setInitialStoreState());
}
