import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/library_reservations_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsCard extends GenericCard {
  LibraryReservationsCard({Key? key}) : super(key: key);

  const LibraryReservationsCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  onClick(BuildContext context) => Navigator.pushNamed(
      context, '/${DrawerItem.navLibraryReservations.title}');

  @override
  String getTitle() => 'Gabinetes Reservados';

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer<LibraryReservationsProvider> (
      builder: (context, reservationsProvider, _) {
      if (reservationsProvider.status == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return RoomsList(reservationsProvider.reservations);
      }
      });
  }
}

class RoomsList extends StatelessWidget {
  final List<LibraryReservation> reservations;

  const RoomsList(this.reservations, {super.key});

  @override
  Widget build(context) {
    if (reservations.isEmpty) {
      return Center(
          child: Text('Não tens salas reservadas!',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center));
    }
    final List<Widget> rooms = [];

    for (int i = 0; i < reservations.length && i < 2; i++) {
      rooms.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations[i])));
    }

    return Column(children: rooms);
  }
}
