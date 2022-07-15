import 'package:flutter/material.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/view/Widgets/estimated_arrival_timestamp.dart';

class TripRow extends StatelessWidget {
  final Trip trip;

  const TripRow({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(trip.line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1),
            Text(trip.destination,
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          Text('${trip.timeRemaining}\'',
              style: Theme.of(context).textTheme.subtitle1),
          EstimatedArrivalTimeStamp(
              timeRemaining: trip.timeRemaining.toString()),
        ])
      ],
    );
  }
}
