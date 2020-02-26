import 'dart:async';
import 'dart:io';
import 'package:flutter/painting.dart';
import 'package:uni/controller/local_storage/AppBusStopDatabase.dart';
import 'package:uni/controller/local_storage/AppLastUserInfoUpdateDatabase.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/AppState.dart';
import 'package:uni/redux/ActionCreators.dart';
import 'package:uni/view/Pages/GeneralPageView.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
  (await AppLastUserInfoUpdateDatabase()).deleteLastUpdate();
  (await AppBusStopDatabase()).deleteBusStops();

  final path = (await getApplicationDocumentsDirectory()).path;
  (new File('$path/profile_pic.png')).delete();
  WidgetsBinding.instance.removeObserver(GeneralPageViewState.lifeCycleEventHandler);
  GeneralPageViewState.decorageImage = null;
  GeneralPageViewState.lifeCycleEventHandler = null;
  PaintingBinding.instance.imageCache.clear();
  (await DefaultCacheManager()).emptyCache();

  StoreProvider.of<AppState>(context).dispatch(setInitialStoreState());
}
