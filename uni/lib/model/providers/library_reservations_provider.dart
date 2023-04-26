import 'dart:async';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/app_library_reservation.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class LibraryReservationsProvider extends StateProviderNotifier {
  List<LibraryReservation>? _reservations;

  List<LibraryReservation> get reservations => _reservations ?? [];

  void getLibraryReservations(
    Session session,
    Completer<void> action,
  ) async {
    try {
      updateStatus(RequestStatus.busy);

      final List<LibraryReservation> reservations =
          await LibraryReservationsFetcherHtml().getReservations(session);

      final LibraryReservationDatabase db = LibraryReservationDatabase();
      db.saveReservations(reservations);

      notifyListeners();
      _reservations = reservations;
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Reservations: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }

  Future<void> updateStateBasedOnLocalReservations() async {
    final LibraryReservationDatabase db = LibraryReservationDatabase();
    final List<LibraryReservation> reservations = await db.reservations();

    _reservations = reservations;
    notifyListeners();
  }

  Future<bool> cancelReservation(Session session, String id) async {
    final url =
        '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_cancelar?pct_pedido_id=$id';

    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final Response response =
        await NetworkRouter.getWithCookies(url, {}, session);

    if (response.statusCode == 200) {
      _reservations!
          .remove(_reservations!.firstWhere((element) => element.id == id));
      notifyListeners();
      return true;
    }
    return false;
  }
}
