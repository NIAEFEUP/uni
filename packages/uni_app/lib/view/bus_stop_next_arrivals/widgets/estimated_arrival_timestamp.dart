import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';

/// Manages the section with the estimated time for the bus arrival
class EstimatedArrivalTimeStamp extends StatelessWidget {
  const EstimatedArrivalTimeStamp({
    required this.timeRemaining,
    super.key,
  });

  final String timeRemaining;

  @override
  Widget build(BuildContext context) {
    return Consumer<BusStopProvider>(
      builder: (context, busProvider, _) =>
          getContent(context, busProvider.lastUpdateTime ?? DateTime.now()),
    );
  }

  Widget getContent(BuildContext context, DateTime timeStamp) {
    final estimatedTime =
        timeStamp.add(Duration(minutes: int.parse(timeRemaining), seconds: 30));

    var num = estimatedTime.hour;
    final hour = num >= 10 ? '$num' : '0$num';
    num = estimatedTime.minute;
    final minute = num >= 10 ? '$num' : '0$num';

    return Text(
      '$hour:$minute',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
