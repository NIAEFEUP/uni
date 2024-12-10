import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<String> getConnectivityStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // Returns the type of connection of the device
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }
}
