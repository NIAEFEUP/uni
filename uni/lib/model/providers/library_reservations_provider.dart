import 'dart:async';

import 'package:html/parser.dart';
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

  Future<bool> makeReservation(
      Session session, String date, String hour, String duration) async {
    final url =
        '${NetworkRouter.getBaseUrl('feup')}res_recursos_geral.pedidos_valida';

    final Map<String, dynamic> body = {
      'p_motivo': '',
      'p_obs': '',
      'pct_grupo_id': '7',
      'p_quantidade': '1',
      'p_data_inicio': date,
      'p_hora_inicio': hour,
      'p_duracao': duration,
      'p_beneficiario': session.studentNumber,
      'p_automatica': 'S'
    };

    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await post(url.toUri(), headers: headers, body: body);
    final document = parse(response.body);
    final String redirect = document.querySelector('a')!.attributes['href']!;
    final sessionId =
        Uri.dataFromString(redirect).queryParameters['pct_session_id'];

    body['pct_session_id'] = sessionId;
    body['pi_confirmacao'] = '1';

    final reserveResponse =
        await post(url.toUri(), headers: headers, body: body);
    if (reserveResponse.statusCode == 200) {
      //_reservations.add(LibraryReservation(_id, room, startDate, duration))
      return true;
    }
    return false;
  }
}
