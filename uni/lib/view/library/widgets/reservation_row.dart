import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class ReservationRow extends StatelessWidget {
  final LibraryReservation reservation;
  late final String hoursStart;
  late final String hoursEnd;
  late final String weekDay;
  late final String day;
  late final String month;

  ReservationRow(this.reservation, {super.key}) {
    hoursStart = DateFormat('HH:mm').format(reservation.startDate);
    hoursEnd = DateFormat('HH:mm')
        .format(reservation.startDate.add(reservation.duration));
    weekDay = TimeString.getWeekdaysStrings(
        startMonday: false)[reservation.startDate.weekday];
    day = DateFormat('dd').format(reservation.startDate);
    initializeDateFormatting();
    month = DateFormat('MMMM', 'pt').format(reservation.startDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(children: [
            Text(
              hoursStart,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              hoursEnd,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ]),
          Column(
            children: [
              Text(reservation.room,
                  //textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.apply(color: Theme.of(context).colorScheme.tertiary)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text(
                '$weekDay, $day de $month',
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          ReservationRemoveButton(reservation)
        ]);
  }
}

class ReservationRemoveButton extends StatelessWidget {
  final LibraryReservation reservation;

  const ReservationRemoveButton(this.reservation, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension / 3,
            minWidth: kMinInteractiveDimension / 3),
        icon: const Icon(Icons.close),
        iconSize: 24,
        color: Colors.grey,
        alignment: Alignment.centerRight,
        tooltip: 'Cancelar reserva',
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext toastContext) {
                return AlertDialog(
                  content: Text(
                    'Queres cancelar este pedido?',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  actions: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed: () => Navigator.of(toastContext).pop(),
                          child: const Text('Voltar')),
                      ElevatedButton(
                          child: const Text('Confirmar'),
                          onPressed: () async {
                            cancelReservation(context, reservation.id);
                          })
                    ])
                  ],
                );
              });
        });
  }

  cancelReservation(context, String id) async {
    final Session session =
        Provider.of<SessionProvider>(context, listen: false).session;

    final stateProviders = StateProviders.fromContext(context);
    final bool result = await stateProviders.libraryReservationsProvider
        .cancelReservation(session, id);

    if (result) {
      Navigator.of(context).pop(false);
      return ToastMessage.success(context, 'A reserva foi cancelada!');
    } else {
      return ToastMessage.error(
          context, 'Ocorreu um erro ao cancelar a reserva!');
    }
  }
}
