import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/services/connectivity_service.dart';
import 'package:uni_ui/theme.dart';

class ConnectivityWarning extends StatefulWidget {
  const ConnectivityWarning({super.key});

  @override
  State<ConnectivityWarning> createState() => _ConnectivityWarningState();
}

class _ConnectivityWarningState extends State<ConnectivityWarning> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isOffline = false;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((offline) {
          setState(() {
            isOffline = offline;
          });
        });
  }

  Future<void> _checkInitialConnection() async {
    final offline = await _connectivityService.checkConnection();
    setState(() {
      isOffline = offline;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isOffline,
      child: Tooltip(
        margin: const EdgeInsets.only(right: 65, bottom: 10),
        message: S.of(context).check_internet,
        triggerMode: TooltipTriggerMode.tap,
        waitDuration: Duration.zero,
        showDuration: const Duration(seconds: 2),
        verticalOffset: 18,
        decoration: BoxDecoration(
          color: Theme.of(context).secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: Theme.of(context).primaryVibrant),
        child: Icon(Icons.signal_wifi_off, color: Theme.of(context).secondary, size: 18), // use uni_ui icons instead
      ),
    );
  }
}
