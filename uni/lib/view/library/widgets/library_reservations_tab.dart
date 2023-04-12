import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/library_reservations_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsTab extends StatelessWidget {
  const LibraryReservationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryReservationsProvider>(
        builder: (context, reservationsProvider, _) {
      if (reservationsProvider.reservations == null ||
          reservationsProvider.status == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryReservationsTabView(reservationsProvider.reservations);
      }
    });
  }
}

class LibraryReservationsTabView extends StatelessWidget {
  final List<LibraryReservation>? reservations;

  const LibraryReservationsTabView(this.reservations, {super.key});

  @override
  Widget build(BuildContext context) {
    if (reservations == null || reservations!.isEmpty) {
      return ListView(scrollDirection: Axis.vertical, children: [
        Center(
            heightFactor: 2,
            child: Text('Não tens salas reservadas',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center))
      ]);
    }
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          LibraryReservationsList(reservations!),
        ]);
  }
}

class LibraryReservationsList extends StatelessWidget {
  final List<LibraryReservation> reservations;

  const LibraryReservationsList(this.reservations, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rooms = [];

    for (int i = 0; i < reservations.length && i < 2; i++) {
      rooms.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1))),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations[i])));
    }

    return Column(children: rooms);
  }
}
