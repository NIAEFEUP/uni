import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/view/lazy_consumer.dart';

class LastUpdateTimeStamp<T extends StateProviderNotifier>
    extends StatefulWidget {
  const LastUpdateTimeStamp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LastUpdateTimeStampState<T>();
  }
}

class _LastUpdateTimeStampState<T extends StateProviderNotifier>
    extends State<LastUpdateTimeStamp> {
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(
        const Duration(seconds: 60),
        (timer) => {
              if (mounted)
                {
                  setState(() {
                    currentTime = DateTime.now();
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<T>(
        builder: (context, provider) => Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: provider.lastUpdateTime != null
                  ? _getContent(context, provider.lastUpdateTime!)
                  : null,
            ));
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
              style: Theme.of(context).textTheme.titleSmall)
        ]);
  }
}
