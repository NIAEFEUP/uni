import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';

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

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((result) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/circle-alert.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
              width: 21,
              height: 21,
            ),
            const SizedBox(width: 8),
            Text(
              S.of(context).internet_status_exception,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
