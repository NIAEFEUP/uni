import 'package:flutter/material.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/view/lazy_consumer.dart';

/// Manages the section with the estimated time for the bus arrival
class EstimatedArrivalTimeStamp extends StatelessWidget {
  final String timeRemaining;

  const EstimatedArrivalTimeStamp({
    Key? key,
    required this.timeRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<BusStopProvider>(
      builder: (context, busProvider) =>
          getContent(context, busProvider.timeStamp),
    );
  }

  Widget getContent(BuildContext context, DateTime timeStamp) {
    final DateTime estimatedTime =
        timeStamp.add(Duration(minutes: int.parse(timeRemaining), seconds: 30));

    int num = estimatedTime.hour;
    final String hour = (num >= 10 ? '$num' : '0$num');
    num = estimatedTime.minute;
    final String minute = (num >= 10 ? '$num' : '0$num');

    return Text('$hour:$minute',
        style: Theme.of(context).textTheme.titleMedium);
  }
}
