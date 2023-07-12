import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_providers.dart';

Future loadReloginInfo(StateProviders stateProviders) async {
  final Tuple2<String, String> userPersistentCredentials =
      await AppSharedPreferences.getPersistentUserInfo();
  final String userName = userPersistentCredentials.item1;
  final String password = userPersistentCredentials.item2;
  final List<String> faculties = await AppSharedPreferences.getUserFaculties();

  if (userName != '' && password != '') {
    final action = Completer();
    stateProviders.sessionProvider
        .reLogin(userName, password, faculties, stateProviders, action: action);
    return action.future;
  }
  return Future.error('No credentials stored');
}

Future loadRemoteUserInfoToState(StateProviders stateProviders) async {
  if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    return;
  }

  Logger().i('Loading remote info');

  final session = stateProviders.sessionProvider.session;
  if (!session.authenticated && session.persistentSession) {
    await loadReloginInfo(stateProviders);
  }

  final Completer<void> userInfo = Completer(),
      ucs = Completer(),
      exams = Completer(),
      schedule = Completer(),
      printBalance = Completer(),
      fees = Completer(),
      trips = Completer(),
      lastUpdate = Completer(),
      restaurants = Completer(),
      libraryOccupation = Completer(),
      calendar = Completer(),
      references = Completer();

  stateProviders.profileStateProvider.getUserInfo(userInfo, session);
  stateProviders.busStopProvider.getUserBusTrips(trips);
  stateProviders.restaurantProvider
      .getRestaurantsFromFetcher(restaurants, session);
  stateProviders.calendarProvider.getCalendarFromFetcher(session, calendar);
  stateProviders.libraryOccupationProvider
      .getLibraryOccupation(session, libraryOccupation);

  final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();

  userInfo.future.then((value) {
    final profile = stateProviders.profileStateProvider.profile;
    final currUcs = stateProviders.profileStateProvider.currUcs;
    stateProviders.examProvider.getUserExams(
        exams, ParserExams(), userPersistentInfo, profile, session, currUcs);
    stateProviders.lectureProvider
        .getUserLectures(schedule, userPersistentInfo, session, profile);
    stateProviders.profileStateProvider
        .getCourseUnitsAndCourseAverages(session, ucs);
    stateProviders.profileStateProvider
        .getUserPrintBalance(printBalance, session);
    stateProviders.profileStateProvider.getUserFees(fees, session);
    stateProviders.referenceProvider.getUserReferences(references, userPersistentInfo, session);
  });

  final allRequests = Future.wait([
    ucs.future,
    exams.future,
    schedule.future,
    printBalance.future,
    fees.future,
    userInfo.future,
    trips.future,
    restaurants.future,
    libraryOccupation.future,
    calendar.future,
    references.future,
  ]);
  allRequests.then((futures) {
    stateProviders.lastUserInfoProvider
        .setLastUserInfoUpdateTimestamp(lastUpdate);
  });
  return lastUpdate.future;
}

void loadLocalUserInfoToState(StateProviders stateProviders,
    {skipDatabaseLookup = false}) async {
  final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();

  Logger().i('Setting up user preferences');
  stateProviders.favoriteCardsProvider
      .setFavoriteCards(await AppSharedPreferences.getFavoriteCards());
  stateProviders.examProvider.setFilteredExams(
      await AppSharedPreferences.getFilteredExams(), Completer());
  stateProviders.examProvider
      .setHiddenExams(await AppSharedPreferences.getHiddenExams(), Completer());
  stateProviders.userFacultiesProvider
      .setUserFaculties(await AppSharedPreferences.getUserFaculties());

  if (userPersistentInfo.item1 != '' &&
      userPersistentInfo.item2 != '' &&
      !skipDatabaseLookup) {
    await stateProviders.lastUserInfoProvider.updateStateBasedOnLocalTime();
    Logger().i('Fetching local info from database');
    stateProviders.examProvider.updateStateBasedOnLocalUserExams();
    stateProviders.lectureProvider.updateStateBasedOnLocalUserLectures();
    stateProviders.examProvider.updateStateBasedOnLocalUserExams();
    stateProviders.lectureProvider.updateStateBasedOnLocalUserLectures();
    stateProviders.busStopProvider.updateStateBasedOnLocalUserBusStops();
    stateProviders.profileStateProvider.updateStateBasedOnLocalProfile();
    stateProviders.profileStateProvider.updateStateBasedOnLocalRefreshTimes();
    stateProviders.restaurantProvider.updateStateBasedOnLocalRestaurants();
    stateProviders.calendarProvider.updateStateBasedOnLocalCalendar();
    stateProviders.profileStateProvider.updateStateBasedOnLocalCourseUnits();
    stateProviders.referenceProvider.updateStateBasedOnLocalUserReferences();
  }

  stateProviders.facultyLocationsProvider.getFacultyLocations(Completer());
}

Future<void> handleRefresh(StateProviders stateProviders) async {
  await loadRemoteUserInfoToState(stateProviders);
}

Future<File?> loadProfilePicture(Session session, {forceRetrieval = false}) {
  final String studentNumber = session.studentNumber;
  return loadUserProfilePicture(studentNumber, session,
      forceRetrieval: forceRetrieval);
}

Future<File?> loadUserProfilePicture(String studentNumber, Session session,
    {forceRetrieval = false}) {
  final String studentNumberDigits =
      studentNumber.replaceAll(RegExp(r'\D'), '');
  final String url =
      'https://sigarra.up.pt/${session.faculties[0]}/pt/fotografias_service.foto?pct_cod=$studentNumberDigits';
  final Map<String, String> headers = <String, String>{};
  headers['cookie'] = session.cookies;
  return loadFileFromStorageOrRetrieveNew(
      '${studentNumber}_profile_picture', url, headers,
      forceRetrieval: forceRetrieval);
}
