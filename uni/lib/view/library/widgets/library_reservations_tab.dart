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
    return LazyConsumer<LibraryReservationsProvider, List<LibraryReservation>>(
      builder: (context, reservations) {
        return LibraryReservationsTabView(reservations);
      },
      contentLoadingWidget: const Center(child: CircularProgressIndicator()),
      hasContent: (reservations) => reservations.isNotEmpty,
      onNullContent: Center(
        child: Text(
          S.of(context).no_reservations,
          style: const TextStyle(fontSize: 18),
        ),
      ),
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
    return Column(
      children: reservations
          .map(
            (reservation) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              margin: const EdgeInsets.all(8),
              child: ReservationRow(reservation),
            ),
          )
          .toList(),
    );
  }
}
