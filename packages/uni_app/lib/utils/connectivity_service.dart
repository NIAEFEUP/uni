import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isOffline);
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isOffline(result);
  }

  bool _isOffline(dynamic result) {
    if (result is ConnectivityResult) {
      return result == ConnectivityResult.none;
    } else if (result is List<ConnectivityResult>) {
      return result.contains(ConnectivityResult.none);
    }
    return false;
  }
}
