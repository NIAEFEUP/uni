import 'dart:async';

import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LastUserInfoProvider extends StateProviderNotifier {
  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  setLastUserInfoUpdateTimestamp(Completer<void> action) async {
    _currentTime = DateTime.now();
    notifyListeners();
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    await db.insertNewTimeStamp(currentTime);
    action.complete();
  }

  updateStateBasedOnLocalTime() async {
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    _currentTime = await db.getLastUserInfoUpdateTime();
    notifyListeners();
  }
}
