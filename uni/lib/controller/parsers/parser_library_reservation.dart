import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/library_reservation.dart';

Future<List<LibraryReservation>> getReservationsFromHtml(
  Response response,
) async {
  final document = parse(response.body);

  final reservationHtml = document.getElementsByClassName('d interior');

  return reservationHtml.map((element) {
    final room = element.children[5].firstChild?.text;
    final date = element.children[0].firstChild?.text;
    final hour = element.children[2].firstChild?.text;
    final startDate = DateTime.parse('$date $hour');
    final durationHtml = element.children[4].firstChild?.text;
    final duration = Duration(
      hours: int.parse(durationHtml!.substring(0, 2)),
      minutes: int.parse(durationHtml.substring(3, 5)),
    );
    return LibraryReservation(room!, startDate, duration);
  }).toList();
}
