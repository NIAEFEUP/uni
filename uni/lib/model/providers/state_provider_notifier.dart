import 'package:flutter/cupertino.dart';

import 'package:uni/model/request_status.dart';

abstract class StateProviderNotifier extends ChangeNotifier {
  RequestStatus _status = RequestStatus.none;

  RequestStatus get status => _status;

  void updateStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }
}
