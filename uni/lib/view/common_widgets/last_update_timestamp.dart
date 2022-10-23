import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/last_user_info_provider.dart';

class LastUpdateTimeStamp extends StatefulWidget {
  const LastUpdateTimeStamp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LastUpdateTimeStampState();
  }
}

class _LastUpdateTimeStampState extends State<LastUpdateTimeStamp> {
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(
        const Duration(seconds: 60),
        (timer) => setState(() {
              currentTime = DateTime.now();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LastUserInfoProvider>(
      builder: (context, lastUserInfoProvider, _) => Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
          child: _getContent(context, lastUserInfoProvider.currentTime)),
    );
  }

  Widget _getContent(BuildContext context, DateTime lastUpdateTime) {
    final Duration elapsedTime = currentTime.difference(lastUpdateTime);
    int elapsedTimeMinutes = elapsedTime.inMinutes;
    if (elapsedTimeMinutes < 0) {
      elapsedTimeMinutes = 0;
    }

    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'Atualizado há $elapsedTimeMinutes minuto${elapsedTimeMinutes != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.subtitle2)
        ]);
  }
}
