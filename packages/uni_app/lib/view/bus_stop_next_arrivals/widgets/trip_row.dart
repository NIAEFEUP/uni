import 'package:flutter/material.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/estimated_arrival_timestamp.dart';

class TripRow extends StatelessWidget {
  const TripRow({
    required this.trip,
    super.key,
  });
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              trip.line,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              trip.destination,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${trip.timeRemaining}'",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            EstimatedArrivalTimeStamp(
              timeRemaining: trip.timeRemaining.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
