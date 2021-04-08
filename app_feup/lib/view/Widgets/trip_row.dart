import 'package:uni/model/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/estimated_arrival_timestamp.dart';

class TripRow extends StatelessWidget {
  final Trip trip;

  TripRow({
    Key key,
    @required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.trip.line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontWeightDelta: 2)),
            Text(this.trip.destination,
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          Text(this.trip.timeRemaining.toString() + '\'',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .apply(fontWeightDelta: 2)),
          EstimatedArrivalTimeStamp(
              timeRemaining: this.trip.timeRemaining.toString()),
        ])
      ],
    );
  }
}
