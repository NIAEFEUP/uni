import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_library_reservation.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/session.dart';

/// Get the library rooms' reservations from the website
class LibraryReservationsFetcherHtml implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Implement parsers for all faculties
    // and dispatch for different fetchers
    // ignore: lines_longer_than_80_chars
    return ['${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_list?pct_tipo_grupo_id=3'];
  }

  Future<List<LibraryReservation>> getReservations(Session session) async {
    final baseUrl = getEndpoints(session)[0];
    final response = NetworkRouter.getWithCookies(baseUrl, {}, session);
    final reservations = await response.then(getReservationsFromHtml);

    return reservations;
  }
}
