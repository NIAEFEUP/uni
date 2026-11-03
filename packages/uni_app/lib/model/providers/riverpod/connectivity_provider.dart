import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/services/connectivity_service.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService().onConnectivityChanged;
});
