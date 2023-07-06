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

  /*void ensureInitialized() {
    if (!_initialized) {
      _initialized = true;
      loadFromStorage();
      loadFromRemote();
    }
  }

  void loadFromStorage();

  void loadFromRemote();*/
}
