import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/view/library/widgets/library_reservations_card.dart';

class LibraryReservationsTab extends StatelessWidget {
  const LibraryReservationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,
        Tuple2<List<LibraryReservation>?, RequestStatus>>(converter: (store) {
      final List<LibraryReservation>? reservations =
          store.state.content['reservations'];
      return Tuple2(reservations, store.state.content['reservationsStatus']);
    }, builder: (context, reservationsInfo) {
      if (reservationsInfo.item2 == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryReservationsList(reservationsInfo.item1);
      }
    });
  }
}

class LibraryReservationsList extends StatelessWidget {
  final List<LibraryReservation>? reservations;

  const LibraryReservationsList(this.reservations, {super.key});

  @override
  Widget build(BuildContext context) {
    if (reservations == null || reservations!.isEmpty) {
      return ListView(scrollDirection: Axis.vertical, children: [
        Center(
            heightFactor: 2,
            child: Text('Não existem dados para apresentar',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center))
      ]);
    }
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          LibraryReservationsCard(),
        ]);
  }
}
