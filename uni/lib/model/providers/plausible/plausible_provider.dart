import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:plausible_analytics/plausible_analytics.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

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
  bool _isUsageStatsEnabled = true;

  bool _canUpdateBatteryState = true;

  @override
  void initState() {
    super.initState();

    final plausible = widget.plausible;
    if (plausible != null) {
      plausible.enabled = false;

      unawaited(
        _startListeners(plausible)
            .then((_) => _updateBatteryState())
            .then((_) => _updateConnectivityState())
            .then((_) => _updateUsageStatsState())
            .onError((error, stackTrace) {
          unawaited(Sentry.captureException(error, stackTrace: stackTrace));
          Logger().e(
            'Error initializing plausible: $error',
            stackTrace: stackTrace,
          );
        }),
      );
    }
  }

  void _updateAnalyticsState() {
    final plausible = widget.plausible;
    if (plausible != null) {
      plausible.enabled = _isUsageStatsEnabled &&
          !_isInBatterySaveMode &&
          _batteryLevel > 20 &&
          _connectivityResult == ConnectivityResult.wifi;

      Logger().d('Plausible enabled: ${plausible.enabled}');
    }
  }

  Future<void> _updateBatteryState() async {
    if (!_canUpdateBatteryState) {
      return;
    }

    _canUpdateBatteryState = false;
    Timer(const Duration(minutes: 1), () => _canUpdateBatteryState = true);

    final battery = Battery();
    _batteryLevel = await battery.batteryLevel;

    try {
      _isInBatterySaveMode = await battery.isInBatterySaveMode;
    } on PlatformException catch (_) {
      _isInBatterySaveMode = false;
    }

    _updateAnalyticsState();
  }

  Future<void> _updateConnectivityState() async {
    final connectivity = Connectivity();
    _connectivityResult = await connectivity.checkConnectivity();

    _updateAnalyticsState();
  }

  Future<void> _updateUsageStatsState() async {
    _isUsageStatsEnabled = PreferencesController.getUsageStatsToggle();
    _updateAnalyticsState();
  }

  Future<void> _startListeners(Plausible plausible) async {
    final connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      _connectivityResult = result;
      _updateAnalyticsState();
    });

    PreferencesController.onStatsToggle.listen((event) {
      _isUsageStatsEnabled = event;
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
