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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<T>(
      builder: (context, provider) => Container(
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
          'Atualizado há $elapsedTimeMinutes '
          'minuto${elapsedTimeMinutes != 1 ? 's' : ''}',
          style: Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }
}
