import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class ConnectivityWarning extends StatefulWidget {
  const ConnectivityWarning({super.key});

  @override
  State<ConnectivityWarning> createState() => _ConnectivityWarningState();
}

class _ConnectivityWarningState extends State<ConnectivityWarning> {
  bool isOffline = false;

  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    checkInitialConnection();

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = result == ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isOffline,
      child: Tooltip(
        margin: const EdgeInsets.only(right: 62, bottom: 22),
        message: S.of(context).internet_status_exception,
        triggerMode: TooltipTriggerMode.tap,
        waitDuration: Duration.zero,
        showDuration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        child: Icon(
          Icons.signal_wifi_off,
          color: Theme.of(context).primaryColor,
          size: 21,
        ),
      ),
    );
  }
}
