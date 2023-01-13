import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher {

  static const printURL = 'https://print.up.pt';

  static Future getBalance(Session session){
    const String url = '$printURL/app?service=page/UserSummary';
    return NetworkRouter.getWithCookies(url, {}, session);
  } 

  static Future generatePrintMoneyReference(
      double amount, Session session) async {
    if (amount < 1.0) return Future.error('Amount less than 1,00€');

    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}gpag_ccorrentes_geral.gerar_mb';

    final Map data = {
      'p_tipo_id': '3',
      'pct_codigo': session.studentNumber,
      'p_valor': '1',
      'p_valor_livre': amount.toStringAsFixed(2).trim().replaceAll('.', ',')
    };

    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;
    headers['content-type'] = 'application/x-www-form-urlencoded';

    final response = await http.post(url.toUri(), headers: headers, body: data);

    return response;
  }
}
