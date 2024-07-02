import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = '${NetworkRouter.getBaseUrl('feup')}imp4_impressoes.atribs';
    // endpoint only available for feup
    return [url];
  }

  Future<http.Response> getUserPrintsResponse(Session session) {
    final url = getEndpoints(session)[0];
    final query = {'p_codigo': session.username};
    return NetworkRouter.getWithCookies(url, query, session);
  }

  static Future<http.Response> generatePrintMoneyReference(
    double amount,
    Session session,
  ) async {
    if (amount < 1.0) {
      return Future.error('Amount less than 1,00€');
    }

    final url = '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'gpag_ccorrentes_geral.gerar_mb';

    final data = {
      'p_tipo_id': '3',
      'pct_codigo': session.username,
      'p_valor': '1',
      'p_valor_livre': amount.toStringAsFixed(2).trim().replaceAll('.', ','),
    };

    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await http.post(url.toUri(), headers: headers, body: data);

    return response;
  }
}
