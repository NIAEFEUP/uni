import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/connectivity_service.dart';

class ConnectivityWarning extends StatefulWidget {
  const ConnectivityWarning({super.key});

  @override
  State<ConnectivityWarning> createState() => _ConnectivityWarningState();
}

class _ConnectivityWarningState extends State<ConnectivityWarning> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
    _connectivityService.connectionStream.listen((isConnected) {
      setState(() {
        isOffline = !isConnected;
      });
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
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
