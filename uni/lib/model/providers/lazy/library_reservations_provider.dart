import 'dart:async';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/controller/fetchers/library_reservation_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_library_reservation.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_library_reservation.dart';
import 'package:uni/model/entities/library_reservation.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class LibraryReservationsProvider
    extends StateProviderNotifier<List<LibraryReservation>> {
  LibraryReservationsProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 1));
  bool _isReserving = false;

  bool get isReserving => _isReserving;

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
    final url = '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral'
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

  Future<bool> makeReservation(
    Session session,
    String date,
    String hour,
    String duration,
  ) async {
    if (_isReserving) {
      return false;
    } else {
      _isReserving = true;
      notifyListeners();
    }

    final url =
        '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_valida';

    final body = <String, dynamic>{
      'p_motivo': '',
      'p_obs': '',
      'pct_grupo_id': '7',
      'p_quantidade': '1',
      'p_data_inicio': date,
      'p_hora_inicio': hour,
      'p_duracao': duration,
      'p_beneficiario': session.username,
      'p_automatica': 'S',
    };

    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await post(url.toUri(), headers: headers, body: body);
    final document = parse(response.body);
    final redirect = document.querySelector('a')!.attributes['href']!;
    if (redirect == '#ancora-conteudo') {
      _isReserving = false;
      notifyListeners();
      return false;
    }
    final sessionId =
        Uri.dataFromString(redirect).queryParameters['pct_session_id'];

    body['pct_session_id'] = sessionId;
    body['pi_confirmacao'] = '1';

    final reserveResponse =
        await post(url.toUri(), headers: headers, body: body);
    _isReserving = false;
    if (reserveResponse.statusCode == 200) {
      final infoUrl =
          '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_view'
          '?pct_pedido_id=$sessionId';
      final reserveInfo = await get(infoUrl.toUri(), headers: headers);
      final reservation = getReservationFromRequest(reserveInfo);
      state?.add(reservation);
      notifyListeners();
      return true;
    }
    return false;
  }
}
