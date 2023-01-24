import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_print.dart';
import 'package:uni/model/entities/print_job.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class PrintProvider extends StateProviderNotifier {
  String _printBalance = "0,0";
  List<PrintJob> _jobs = [];
  DateTime? _refreshTime;
  DateTime? _printRefreshTime;

  String get printBalance => _printBalance;
  String get printRefreshTime => _printRefreshTime?.toString() ?? '';

  UnmodifiableListView<PrintJob> get jobs => UnmodifiableListView(_jobs);

  String get refreshTime => _refreshTime?.toString() ?? '';

  //TODO:
  updateStateBasedOnLocalJobs() async {}

  getUserJobs(Completer<void> action, Session session) async {
    try {
      final response = await PrintFetcher.getPendingJobs(session);

      final List<PrintJob> jobs = await getPendingReleases(response);

      final DateTime currentTime = DateTime.now();
      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();

      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('print-jobs', currentTime.toString());

        // TODO: Store jobs info
      }

      _jobs = jobs;
      _refreshTime = currentTime;
      notifyListeners();
    } catch (e) {
      Logger().e('Failed to get Print Jobs: $e');
    }

    action.complete();
  }

  Future storeRefreshTime(String db, String currentTime) async {
    final AppRefreshTimesDatabase refreshTimesDatabase =
        AppRefreshTimesDatabase();
    refreshTimesDatabase.saveRefreshTime(db, currentTime);
  }

  Future cancelJob(PrintJob job, Session session) async {
    try {
      await NetworkRouter.getWithCookies(job.cancelUrl, {}, session);

      final Completer<void> action = Completer<void>();
      getUserJobs(action, session);
    } catch (e) {
      Logger().e('Failed to cancel print job');
    }
  }

  getUserPrintBalance(Completer<void> action, Session session) async {
    try {
      final response = await PrintFetcher.getBalance(session);
      final String printBalance = await getPrintsBalance(response);

      _printBalance = printBalance;
      notifyListeners();

      final DateTime currentTime = DateTime.now();
      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('print', currentTime.toString());

        // Store fees info
        // TODO: use a future database just for prints and not the user database
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserPrintBalance(printBalance);
      }
    } catch (e) {
      Logger().e('Failed to get Print Balance $e');
    }

    action.complete();
  }

  updateStateBasedOnLocalRefreshTimes() async {
    final AppRefreshTimesDatabase refreshTimesDb = AppRefreshTimesDatabase();
    final Map<String, String> refreshTimes =
        await refreshTimesDb.refreshTimes();

    final printRefreshTime = refreshTimes['print'];
    if (printRefreshTime != null) {
      _printRefreshTime = DateTime.parse(printRefreshTime);
    }
  }

  //TODO: move generatePrintMoneyReference to here

}
