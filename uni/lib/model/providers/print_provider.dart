import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_print.dart';
import 'package:uni/model/entities/print_job.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class PrintProvider extends StateProviderNotifier {
  late String _printBalance;
  List<PrintJob> _jobs = [];
  DateTime? _refreshTime;

  String get printBalance => _printBalance;

  UnmodifiableListView<PrintJob> get jobs => UnmodifiableListView(_jobs);

  String get refreshTime => _refreshTime.toString();

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

  //Cancel print job
  Future cancelJob(PrintJob job, Session session) async {
    try {
      await NetworkRouter.getWithCookies(job.cancelUrl, {}, session);

      final Completer<void> action = Completer<void>();
      getUserJobs(action, session);
    } catch (e) {
      Logger().e('Failed to cancel print job');
    }
  }

  //TODO: move getUserPrintBalance to here

  //TODO: move generatePrintMoneyReference to here

}
