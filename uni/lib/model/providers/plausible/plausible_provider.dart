import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:plausible_analytics/plausible_analytics.dart';
import 'package:provider/provider.dart';

class PlausibleProvider extends StatefulWidget {
  const PlausibleProvider({
    required this.plausible,
    required this.child,
    super.key,
  });

  final Plausible? plausible;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _PlausibleProviderState();
}

class _PlausibleProviderState extends State<PlausibleProvider> {
  int _batteryLevel = 0;
  bool _isInBatterySaveMode = true;
  ConnectivityResult _connectivityResult = ConnectivityResult.mobile;

  bool _canUpdateBatteryState = true;

  @override
  void initState() {
    super.initState();

    final plausible = widget.plausible;
    if (plausible != null) {
      plausible.enabled = false;

      _startListeners(plausible)
          .then((_) => _updateBatteryState())
          .then((_) => _updateConnectivityState());
    }
  }

  void _updateAnalyticsState() {
    final plausible = widget.plausible;
    if (plausible != null) {
      plausible.enabled = _batteryLevel > 20 &&
          !_isInBatterySaveMode &&
          _connectivityResult == ConnectivityResult.wifi;
    }
  }

  Future<void> _updateBatteryState() async {
    if (!_canUpdateBatteryState) {
      return;
    }

    _canUpdateBatteryState = false;
    Timer(const Duration(seconds: 10), () => _canUpdateBatteryState = true);

    final battery = Battery();
    _batteryLevel = await battery.batteryLevel;
    _isInBatterySaveMode = await battery.isInBatterySaveMode;

    _updateAnalyticsState();
  }

  Future<void> _updateConnectivityState() async {
    final connectivity = Connectivity();
    _connectivityResult = await connectivity.checkConnectivity();

    _updateAnalyticsState();
  }

  Future<void> _startListeners(Plausible plausible) async {
    final connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      _connectivityResult = result;
      _updateAnalyticsState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        final plausible = widget.plausible;
        if (plausible != null) {
          _updateBatteryState();
        }
      },
      child: Provider.value(
        value: widget.plausible,
        child: widget.child,
      ),
    );
  }
}
