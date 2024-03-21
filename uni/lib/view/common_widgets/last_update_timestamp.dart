import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class LastUpdateTimeStamp<T extends StateProviderNotifier<dynamic>>
    extends StatefulWidget {
  const LastUpdateTimeStamp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LastUpdateTimeStampState<T>();
  }
}

class _LastUpdateTimeStampState<T extends StateProviderNotifier<dynamic>>
    extends State<StatefulWidget> {
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 60),
      (timer) {
        if (mounted) {
          setState(() {
            currentTime = DateTime.now();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, provider, _) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: provider.lastUpdateTime != null
            ? _getContent(context, provider.lastUpdateTime!)
            : null,
      ),
    );
  }

  Widget _getContent(BuildContext context, DateTime lastUpdateTime) {
    final elapsedTime = currentTime.difference(lastUpdateTime);
    var elapsedTimeMinutes = elapsedTime.inMinutes;
    if (elapsedTimeMinutes < 0) {
      elapsedTimeMinutes = 0;
    }

    return Row(
      children: [
        Text(
          S.of(context).last_timestamp(elapsedTimeMinutes),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
