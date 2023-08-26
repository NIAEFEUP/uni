import 'dart:async';

import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/app_library_reservation.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class LibraryReservationsProvider extends StateProviderNotifier {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  List<LibraryReservation> _reservations = [];

  List<LibraryReservation> get reservations => _reservations;

  @override
  Future<void> loadFromStorage() async {
    final db = LibraryReservationDatabase();
    final reservations = await db.reservations();

    _reservations = reservations;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchLibraryReservations(session);
  }

  Future<void> fetchLibraryReservations(
    Session session,
  ) async {
    try {
      _reservations =
          await LibraryReservationsFetcherHtml().getReservations(session);

      final db = LibraryReservationDatabase();
      unawaited(db.saveReservations(reservations));

      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  Future<bool> cancelReservation(Session session, String id) async {
    final url =
        '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_cancelar?pct_pedido_id=$id';

    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await NetworkRouter.getWithCookies(url, {}, session);

    if (response.statusCode == 200) {
      _reservations
          .remove(_reservations.firstWhere((element) => element.id == id));
      notifyListeners();
      final db = LibraryReservationDatabase();
      unawaited(db.saveReservations(reservations));
      return true;
    }
    return false;
  }
}
