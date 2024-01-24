import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/library_reservation.dart';

Future<List<LibraryReservation>> getReservationsFromHtml(
  Response response,
) async {
  final document = parse(response.body);

  final reservationHtml = document.getElementsByClassName('d interior');

  final idHtml = document
      .querySelectorAll('tbody > tr')
      .where(
        (element) =>
            element.children.length == 12 &&
            element.children[11].firstChild!.text == 'Reservado',
      )
      .toList();

  final result = <LibraryReservation>[];
  for (var i = 0; i < reservationHtml.length && i < idHtml.length; i++) {
    final room = reservationHtml[i].children[5].firstChild!.text;
    final date = reservationHtml[i].children[0].firstChild!.text;
    final hour = reservationHtml[i].children[2].firstChild!.text;
    final idRef = idHtml[i].children[11].firstChild!.attributes['href'];
    final id = idRef!.split('=')[1];
    final startDate = DateTime.parse('$date $hour');
    final durationHtml = reservationHtml[i].children[4].firstChild!.text;
    final duration = Duration(
      hours: int.parse(durationHtml!.substring(0, 2)),
      minutes: int.parse(durationHtml.substring(3, 5)),
    );
    result.add(LibraryReservation(id, room!, startDate, duration));
  }
  return result;
}

/// Get room info from the response of a placed reservation request
LibraryReservation getReservationFromRequest(Response response) {
  final document = parse(response.body);

  final id = document.querySelector('tbody tr')!.children[1].text;

  final reservationHtml = document.querySelector('tbody .d')!.children;

  final room = reservationHtml[5].firstChild!.text!;
  final date = reservationHtml[0].text;
  final hour = reservationHtml[2].text;
  final startDate = DateTime.parse('$date $hour');
  final durationHtml = reservationHtml[4].text;
  final duration = Duration(
    hours: int.parse(durationHtml.substring(0, 2)),
    minutes: int.parse(durationHtml.substring(3, 5)),
  );
  return LibraryReservation(id, room, startDate, duration);
}
