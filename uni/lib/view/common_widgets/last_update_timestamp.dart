import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';

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
    return StoreConnector<AppState, DateTime?>(
      converter: (store) => store.state.content['timeStamp'],
      builder: (context, timeStamp) {
        return Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
            child: _getContent(context, timeStamp ?? DateTime.now()));
      },
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
