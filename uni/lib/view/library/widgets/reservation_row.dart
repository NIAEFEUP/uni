import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/view/locale_notifier.dart';

class ReservationRow extends StatelessWidget {
  ReservationRow(this.reservation, {super.key}) {
    initializeDateFormatting();
  }
  final LibraryReservation reservation;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('dd').format(reservation.startDate);
    final month = DateFormat('MMMM', 'pt').format(reservation.startDate);
    final weekdays =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final weekDay = weekdays[reservation.startDate.weekday - 1];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: [
            Text(
              DateFormat('HH:mm').format(reservation.startDate),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              DateFormat('HH:mm')
                  .format(reservation.startDate.add(reservation.duration)),
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
              '$weekDay, $day ${S.of(context).of_month} $month',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const ReservationRemoveButton(),
      ],
    );
  }
}

class ReservationRemoveButton extends StatelessWidget {
  const ReservationRemoveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(
        minHeight: kMinInteractiveDimension / 3,
        minWidth: kMinInteractiveDimension / 3,
      ),
      icon: const Icon(Icons.close),
      iconSize: 24,
      color: Colors.grey,
      alignment: Alignment.centerRight,
      onPressed: () => {},
    );
  }
}
