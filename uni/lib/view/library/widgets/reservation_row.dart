import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/model/providers/lazy/library_reservations_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/locale_notifier.dart';

class ReservationRow extends StatelessWidget {
  ReservationRow(this.reservation, {super.key}) {
    hoursStart = DateFormat('HH:mm').format(reservation.startDate);
    hoursEnd = DateFormat('HH:mm')
        .format(reservation.startDate.add(reservation.duration));
    weekDay = TimeString.getWeekdaysStrings(
      startMonday: false,
    )[reservation.startDate.weekday];
    day = DateFormat('dd').format(reservation.startDate);
    initializeDateFormatting();
    month = DateFormat('MMMM', 'pt').format(reservation.startDate);
  }
  final LibraryReservation reservation;
  late final String hoursStart;
  late final String hoursEnd;
  late final String weekDay;
  late final String day;
  late final String month;

  @override
  Widget build(BuildContext context) {
    final weekdays =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    weekDay = weekdays[reservation.startDate.weekday];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: [
            Text(
              hoursStart,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              hoursEnd,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Column(
          children: [
            Text(
              reservation.room,
              //textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Theme.of(context).colorScheme.tertiary),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Text(
              '$weekDay, $day de $month',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        ReservationRemoveButton(reservation),
      ],
    );
  }
}

//ignore: must_be_immutable
class ReservationRemoveButton extends StatefulWidget {
  ReservationRemoveButton(this.reservation, {super.key});
  final LibraryReservation reservation;
  late bool loading = false;
  late BuildContext context;

  @override
  State<ReservationRemoveButton> createState() =>
      _ReservationRemoveButtonState();
}

class _ReservationRemoveButtonState extends State<ReservationRemoveButton> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.context = context;
    });
    if (widget.loading) {
      return const CircularProgressIndicator();
    }
    return IconButton(
      constraints: const BoxConstraints(
        minHeight: kMinInteractiveDimension / 3,
        minWidth: kMinInteractiveDimension / 3,
      ),
      icon: const Icon(Icons.close),
      iconSize: 24,
      color: Colors.grey,
      alignment: Alignment.centerRight,
      tooltip: 'Cancelar reserva',
      onPressed: () {
        showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext toastContext) {
            return AlertDialog(
              content: Text(
                'Queres cancelar este pedido?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(toastContext).pop(),
                      child: const Text('Voltar'),
                    ),
                    ElevatedButton(
                      child: const Text('Sim'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        cancelReservation(widget.reservation.id);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> cancelReservation(String id) async {
    if (widget.loading) return;
    setState(() {
      widget.loading = true;
    });
    final session =
        Provider.of<SessionProvider>(widget.context, listen: false).session;
    final result = await Provider.of<LibraryReservationsProvider>(
      widget.context,
      listen: false,
    ).cancelReservation(session, id);

    await displayToast(success: result);
  }

  Future<void> displayToast({
    bool success = true,
  }) async {
    if (success) {
      await ToastMessage.success(widget.context, 'A reserva foi cancelada!');
    } else {
      await ToastMessage.error(
        widget.context,
        'Ocorreu um erro ao cancelar a reserva!',
      );
    }
  }
}
