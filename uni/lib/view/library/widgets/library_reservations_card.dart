import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/lazy/library_reservations_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsCard extends GenericCard {
  LibraryReservationsCard({super.key});

  const LibraryReservationsCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  Future<Object?> onClick(BuildContext context) => Navigator.pushNamed(
        context,
        '/${DrawerItem.navLibraryReservations.title}',
      );

  @override
  String getTitle(BuildContext context) => S.of(context).library_reservations;

  @override
  void onRefresh(BuildContext context) {
    Provider.of<LibraryReservationsProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LibraryReservationsProvider, List<LibraryReservation>>(
      builder: (context, reservations) {
        return RoomsList(reservations);
      },
      contentLoadingWidget: const Center(child: CircularProgressIndicator()),
      hasContent: (reservations) => reservations.isNotEmpty,
      onNullContent: Center(
        child: Text(
          S.of(context).no_reservations,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class RoomsList extends StatelessWidget {
  const RoomsList(this.reservations, {super.key});
  final List<LibraryReservation> reservations;

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Center(
        child: Text(
          S.of(context).no_data,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }
    final rooms = <Widget>[];

    for (var i = 0; i < reservations.length && i < 2; i++) {
      rooms.add(
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations[i]),
        ),
      );
    }

    return Column(children: rooms);
  }
}
