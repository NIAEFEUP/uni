import 'dart:async';

import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LastUserInfoProvider extends StateProviderNotifier {
  DateTime? _lastUpdateTime;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  setLastUserInfoUpdateTimestamp(Completer<void> action) async {
    _lastUpdateTime = DateTime.now();
    notifyListeners();
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    await db.insertNewTimeStamp(_lastUpdateTime!);
    action.complete();
  }

  @override
  void loadFromStorage() async {
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    _lastUpdateTime = await db.getLastUserInfoUpdateTime();
    notifyListeners();
  }
}
