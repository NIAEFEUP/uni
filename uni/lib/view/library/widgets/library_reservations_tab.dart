import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/providers/library_reservations_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/library/widgets/reservation_row.dart';

class LibraryReservationsTab extends StatelessWidget {
  const LibraryReservationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryReservationsProvider>(
        builder: (context, reservationsProvider, _) {
      if (reservationsProvider.status == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryReservationsTabView(reservationsProvider.reservations);
      }
    });
  }
}

class LibraryReservationsTabView extends StatelessWidget {
  final List<LibraryReservation>? reservations;

  const LibraryReservationsTabView(this.reservations, {super.key});

  @override
  Widget build(BuildContext context) {
    if (reservations == null || reservations!.isEmpty) {
      return ListView(scrollDirection: Axis.vertical, children: [
        Center(
            heightFactor: 2,
            child: Text('Não tens salas reservadas',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center)),
        const CreateReservationButton(),
      ]);
    }
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          LibraryReservationsList(reservations!),
        ]);
  }
}

class LibraryReservationsList extends StatelessWidget {
  final List<LibraryReservation> reservations;

  const LibraryReservationsList(this.reservations, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rooms = [];

    for (int i = 0; i < reservations.length && i < 2; i++) {
      rooms.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1))),
          margin: const EdgeInsets.all(8),
          child: ReservationRow(reservations[i])));
    }

    return Column(children: rooms);
  }
}

class CreateReservationButton extends StatelessWidget {
  const CreateReservationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      iconSize: 35,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext toastContext) {
              return const ReservationPicker();
            });
      },
    );
  }
}

class ReservationPicker extends StatefulWidget {
  const ReservationPicker({super.key});

  @override
  State<StatefulWidget> createState() => ReservationPickerState();
}

class ReservationPickerState extends State<ReservationPicker> {
  DateTime? date;
  TimeOfDay? time;
  Duration? duration;
  TextEditingController dateInput = TextEditingController();
  TextEditingController durationInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding:
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      title: const Center(child: Text('Reservar Sala')),
      actions: <Widget>[
        TextField(
            controller: dateInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), labelText: "Data"),
            readOnly: true,
            onTap: () => onTapDate(context)),
        TextField(
            controller: timeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.schedule), labelText: "Hora"),
            readOnly: true,
            onTap: () => onTapTime(context)),
        TextField(
            controller: durationInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.timer), labelText: "Duração"),
            readOnly: true,
            onTap: () => onTapDuration(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => makeReservation(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirmar'),
            ),
          ],
        )
      ],
    );
  }

  void onTapDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(const Duration(days: 1)),
            firstDate: DateTime.now().add(const Duration(days: 1)),
            lastDate: DateTime.now().add(const Duration(days: 7)))
        .then((datePicked) => setState(() {
              date = datePicked;
              dateInput.text =
                  DateFormat('dd-MM-yyyy').format(date ?? DateTime.now());
            }));
  }

  void onTapTime(BuildContext context) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((timePicked) => setState(() {
              time = timePicked;
              timeInput.text = (timePicked ?? TimeOfDay.now()).format(context);
            }));
  }

  void onTapDuration(BuildContext context) async {
    await showDurationPicker(
            context: context, initialTime: const Duration(hours: 1))
        .then((durationPicked) => setState(() {
              duration = durationPicked;
              durationInput.text = (durationPicked ?? const Duration(hours: 1))
                  .toString()
                  .split(':00.')
                  .first
                  .padLeft(5, '0');
            }));
  }

  void makeReservation(BuildContext context) {
    Navigator.of(context).pop();
    // create toast message
  }
}
