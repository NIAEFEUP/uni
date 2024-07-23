import 'package:flutter/material.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/trip_row.dart';

class BusStopRow extends StatelessWidget {
  const BusStopRow({
    required this.stopCode,
    required this.trips,
    super.key,
    this.singleTrip = false,
    this.stopCodeShow = true,
  });
  final String stopCode;
  final List<Trip> trips;
  final bool stopCodeShow;
  final bool singleTrip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getTrips(context),
      ),
    );
  }

  List<Widget> getTrips(BuildContext context) {
    final row = <Widget>[];

    if (stopCodeShow) {
      row.add(stopCodeRotatedContainer(context));
    }

    if (trips.isEmpty) {
      row.add(noTripsContainer(context));
    } else {
      final tripRows = getTripRows(context);

      row.add(Expanded(child: Column(children: tripRows)));
    }

    return row;
  }

  Widget noTripsContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Não há viagens planeadas de momento.',
        maxLines: 3,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget stopCodeRotatedContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(stopCode, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }

  List<Widget> getTripRows(BuildContext context) {
    final tripRows = <Widget>[];

    if (singleTrip) {
      tripRows.add(
        Container(
          padding: const EdgeInsets.all(12),
          child: TripRow(trip: trips[0]),
        ),
      );
    } else {
      for (var i = 0; i < trips.length; i++) {
        tripRows.add(
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.1, /* color: color */
                ),
              ),
            ),
            child: TripRow(trip: trips[i]),
          ),
        );
      }
    }

    return tripRows;
  }
}
