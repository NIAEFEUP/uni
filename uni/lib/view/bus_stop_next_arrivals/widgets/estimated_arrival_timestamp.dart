import 'package:flutter/material.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/view/lazy_consumer.dart';

/// Manages the section with the estimated time for the bus arrival
class EstimatedArrivalTimeStamp extends StatelessWidget {

  const EstimatedArrivalTimeStamp({
    super.key,
    required this.timeRemaining,
  });
  final String timeRemaining;

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<BusStopProvider>(
      builder: (context, busProvider) =>
          getContent(context, busProvider.timeStamp),
    );
  }

  Widget getContent(BuildContext context, DateTime timeStamp) {
    final estimatedTime =
        timeStamp.add(Duration(minutes: int.parse(timeRemaining), seconds: 30));

    var num = estimatedTime.hour;
    final hour = num >= 10 ? '$num' : '0$num';
    num = estimatedTime.minute;
    final minute = num >= 10 ? '$num' : '0$num';

    return Text('$hour:$minute',
        style: Theme.of(context).textTheme.titleMedium,);
  }
}
