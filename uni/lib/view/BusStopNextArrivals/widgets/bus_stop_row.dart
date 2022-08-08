import 'package:flutter/material.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/view/BusStopNextArrivals/widgets/trip_row.dart';

class BusStopRow extends StatelessWidget {
  final String stopCode;
  final List<Trip> trips;
  final bool stopCodeShow;
  final bool singleTrip;

  const BusStopRow({
    Key? key,
    required this.stopCode,
    required this.trips,
    this.singleTrip = false,
    this.stopCodeShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getTrips(context),
      ),
    );
  }

  List<Widget> getTrips(context) {
    final List<Widget> row = <Widget>[];

    if (stopCodeShow) {
      row.add(stopCodeRotatedContainer(context));
    }

    if (trips.isEmpty) {
      row.add(noTripsContainer(context));
    } else {
      final List<Widget> tripRows = getTripRows(context);

      row.add(Expanded(child: Column(children: tripRows)));
    }

    return row;
  }

  Widget noTripsContainer(context) {
    return Text('Não há viagens planeadas de momento.',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1);
  }

  Widget stopCodeRotatedContainer(context) {
    return Container(
      padding: const EdgeInsets.only(left: 4.0),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(stopCode, style: Theme.of(context).textTheme.subtitle1),
      ),
    );
  }

  List<Widget> getTripRows(BuildContext context) {
    final List<Widget> tripRows = <Widget>[];

    if (singleTrip) {
      tripRows.add(Container(
          padding: const EdgeInsets.all(12.0), child: TripRow(trip: trips[0])));
    } else {
      for (int i = 0; i < trips.length; i++) {
/*         Color color = Theme.of(context).accentColor;
        if (i == trips.length - 1) color = Colors.transparent; */

        tripRows.add(Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.1, /* color: color */
            ))),
            child: TripRow(trip: trips[i])));
      }
    }

    return tripRows;
  }
}
