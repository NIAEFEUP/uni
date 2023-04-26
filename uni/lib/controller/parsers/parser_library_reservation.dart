import 'package:http/http.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uni/model/entities/library_reservation.dart';

Future<List<LibraryReservation>> getReservationsFromHtml(Response response) async {
  final document = parse(response.body);

  final List<Element> reservationHtml =
    document.getElementsByClassName('d interior');


  final List<Element> idHtml = 
    document.querySelectorAll('tbody > tr')
    .where((element) => (
      element.children.length == 12
       && element.children[11].firstChild!.text == 'Reservado'
      )).toList();

  final List<LibraryReservation> result = [];
  for (int i = 0; i < reservationHtml.length && i < idHtml.length; i++) {
    final String? room = reservationHtml[i].children[5].firstChild!.text;
    final String? date = reservationHtml[i].children[0].firstChild!.text;
    final String? hour = reservationHtml[i].children[2].firstChild!.text;
    final String? idRef = idHtml[i].children[11].firstChild!.attributes['href'];
    final String id = idRef!.split('=')[1];
    final DateTime startDate = DateTime.parse('$date $hour');
    final String? durationHtml = reservationHtml[i].children[4].firstChild!.text;
    final Duration duration = Duration(
      hours: int.parse(durationHtml!.substring(0,2)),
      minutes: int.parse(durationHtml.substring(3,5))
      );
    result.add(LibraryReservation(id, room!, startDate, duration));
  }
  return result;
}