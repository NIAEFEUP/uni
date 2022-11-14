import 'package:http/http.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uni/model/entities/library_reservation.dart';

Future<List<LibraryReservation>> getReservationsFromHtml(Response response) async {
  final document = parse(response.body);

  final List<Element> reservationHtml =
    document.getElementsByClassName('d interior');

  return reservationHtml.map( (element) {
    final String? room = element.children[5].firstChild?.text;
    final String? date = element.children[0].firstChild?.text;
    final String? hour = element.children[2].firstChild?.text;
    final DateTime startDate = DateTime.parse('$date $hour');
    final String? durationHtml = element.children[4].firstChild?.text;
    final Duration duration = Duration(
      hours: int.parse(durationHtml!.substring(0,2)),
      minutes: int.parse(durationHtml.substring(3,5))
      );
    return LibraryReservation(room!, startDate, duration);
  }).toList();
}