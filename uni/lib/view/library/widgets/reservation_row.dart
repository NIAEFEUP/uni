import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/lazy/library_reservations_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/locale_notifier.dart';

class ReservationRow extends StatelessWidget {
  ReservationRow(this.reservation, {super.key}) {
    hoursStart = DateFormat('HH:mm').format(reservation.startDate);
    hoursEnd = DateFormat('HH:mm')
        .format(reservation.startDate.add(reservation.duration));
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
        Provider.of<LocaleNotifier>(context, listen: false).getWeekdaysWithLocale();
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
        ReservationRemoveButton(context, reservation),
      ],
    );
  }
}

class ReservationRemoveButton extends StatefulWidget {
  const ReservationRemoveButton(this.context, this.reservation, {super.key});
  final LibraryReservation reservation;
  final BuildContext context;

  @override
  State<ReservationRemoveButton> createState() =>
      _ReservationRemoveButtonState();
}

class _ReservationRemoveButtonState extends State<ReservationRemoveButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
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
      tooltip: S.of(context).library_cancel_tooltip,
      onPressed: () {
        showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext toastContext) {
            return AlertDialog(
              content: Text(
                S.of(context).library_cancel_reservation,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(toastContext).pop(),
                      child: Text(S.of(context).go_back),
                    ),
                    ElevatedButton(
                      child: Text(S.of(context).yes),
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
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    final session =
        Provider.of<SessionProvider>(widget.context, listen: false).session;
    final result = await Provider.of<LibraryReservationsProvider>(
      widget.context,
      listen: false,
    ).cancelReservation(session, id);

    if (result) {
      await displayToastSuccess();
    } else {
      await displayToastFailure();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> displayToastSuccess() async {
    await ToastMessage.success(
      widget.context,
      S.of(context).library_cancel_success,
    );
  }

  Future<void> displayToastFailure() async {
    await ToastMessage.error(
      widget.context,
      S.of(context).library_cancel_error,
    );
  }
}
