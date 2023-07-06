import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/request_status.dart';

abstract class StateProviderNotifier extends ChangeNotifier {
  RequestStatus _status = RequestStatus.none;
  bool _initialized = false;

  RequestStatus get status => _status;

  void updateStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }

  void ensureInitialized() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    loadFromStorage();
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      loadFromRemote();
    }

    notifyListeners();
  }

  void loadFromStorage() async {}

  void loadFromRemote() async {}
}
