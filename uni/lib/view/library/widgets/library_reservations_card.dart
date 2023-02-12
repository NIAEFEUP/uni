import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsCard extends GenericCard {
  LibraryReservationsCard({Key? key}) : super(key: key);

  const LibraryReservationsCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navLibrary.title}');

  @override
  String getTitle() => 'Gabinetes Reservados';

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState,
            Tuple2<List<LibraryReservation>?, RequestStatus?>>(
        converter: (store) => Tuple2(store.state.content['reservations'],
            store.state.content['reservationsStatus']),
        builder: (context, roomsInfo) {
          if (roomsInfo.item2 == null ||
              roomsInfo.item2 == RequestStatus.busy) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RoomsList(roomsInfo.item1);
          }
        });
  }
}

class RoomsList extends StatelessWidget {
  final List<LibraryReservation>? reservations;

  const RoomsList(this.reservations, {super.key});

  @override
  Widget build(context) {
    if (reservations == null || reservations!.isEmpty) {
      return Center(
          child: Text('Não tens salas reservadas!',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center));
    }
    final List<Widget> rooms = [];

    for (int i = 0; i < reservations!.length && i < 2; i++) {
      rooms.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations![i])));
    }

    return Column(children: rooms);
  }
}
