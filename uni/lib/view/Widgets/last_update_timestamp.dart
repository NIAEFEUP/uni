import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';

class LastUpdateTimeStamp extends StatelessWidget {
  const LastUpdateTimeStamp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Tuple2<DateTime, DateTime>?>(
      converter: (store) => Tuple2(
          store.state.content['timeStamp'], store.state.content['currentTime']),
      builder: (context, timeStamps) {
        return Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
            child: getContent(context, timeStamps));
      },
    );
  }

  Widget getContent(BuildContext context, timeStamps) {
    final Duration lastUpdate = timeStamps.item2.difference(timeStamps.item1);
    final int lastUpdateMinutes = lastUpdate.inMinutes;

    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'Atualizado há $lastUpdateMinutes minuto${lastUpdateMinutes != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.subtitle2)
        ]);
  }
}
