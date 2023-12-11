import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/lazy/library_reservations_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsTab extends StatelessWidget {
  const LibraryReservationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<LibraryReservationsProvider>(
      builder: (context, reservationsProvider) {
        return LibraryReservationsTabView(reservationsProvider.reservations);
      },
    );
  }

  Future<void> refresh(BuildContext context) async {
    await Provider.of<LibraryReservationsProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

class LibraryReservationsTabView extends StatelessWidget {
  const LibraryReservationsTabView(this.reservations, {super.key});
  final List<LibraryReservation>? reservations;

  @override
  Widget build(BuildContext context) {
    if (reservations == null || reservations!.isEmpty) {
      return ListView(
        children: [
          Center(
            heightFactor: 2,
            child: Text(
              S.of(context).no_data,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    return ListView(
      shrinkWrap: true,
      children: [
        LibraryReservationsList(reservations!),
      ],
    );
  }
}

class LibraryReservationsList extends StatelessWidget {
  const LibraryReservationsList(this.reservations, {super.key});
  final List<LibraryReservation> reservations;

  @override
  Widget build(BuildContext context) {
    final rooms = <Widget>[];

    for (var i = 0; i < reservations.length; i++) {
      rooms.add(
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations[i]),
        ),
      );
    }

    return Column(children: rooms);
  }
}
