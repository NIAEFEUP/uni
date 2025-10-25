import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _controller.stream;

  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _controller.add(result != ConnectivityResult.none);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _controller.add(result != ConnectivityResult.none);
    }) as StreamSubscription<ConnectivityResult>?;
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}