import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
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
            )
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
            )
          ],
        ),
        const ReservationRemoveButton()
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
