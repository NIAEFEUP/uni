import 'dart:async';

import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_library_reservation.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class LibraryReservationsProvider
    extends StateProviderNotifier<List<LibraryReservation>> {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));

  @override
  Future<List<LibraryReservation>> loadFromStorage(
    StateProviders stateProviders,
  ) {
    final db = LibraryReservationDatabase();
    return db.reservations();
  }

  @override
  Future<List<LibraryReservation>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    final session = stateProviders.sessionProvider.state!;
    final reservations =
        await LibraryReservationsFetcherHtml().getReservations(session);

    final db = LibraryReservationDatabase();
    unawaited(db.saveReservations(reservations));

    return reservations;
  }

  Future<bool> cancelReservation(Session session, String id) async {
    final url =
        '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral'
        '.pedidos_cancelar?pct_pedido_id=$id';

    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await NetworkRouter.getWithCookies(url, {}, session);

    if (response.statusCode == 200) {
      state?.remove(state?.firstWhere((element) => element.id == id));
      notifyListeners();
      final db = LibraryReservationDatabase();
      unawaited(db.saveReservations(state!));
      return true;
    }
    return false;
  }
}
