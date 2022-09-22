import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher implements SessionDependantFetcher {
  static const printURL = 'https://print.up.pt';
  
  @override
  List<String> getEndpoints(Session session) {
    final url =
        '${NetworkRouter.getBaseUrl('feup')}imp4_impressoes.atribs'; // endpoint only available for feup
    return [url];
  }

  getUserPrintsResponse(Session session) {
    final String url = getEndpoints(session)[0];
    final Map<String, String> query = {'p_codigo': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
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

  // Print up methods

  //get balance: HTML
  static Future getHomePage(Session session) async {
    const url = '$printURL/app?service=page/UserSummary';
    return await NetworkRouter.getWithCookies(url, {}, session);
  } 
  //get recent movements: CVS 
  static Future getPrintMovements(Session session) async {
    const url = '$printURL/app?service=direct/1/UserTransactions/accTrans.exportLogs.csv&sp=SCSV&sp=F';
    // TODO: explore some way to read the downloaded csv file
  }
  //get recent movements: HTML
  static Future getPendingReleases(Session session) async {
    const url = '$printURL/app?service=direct/1/UserPrintLogs/printLogs.exportPrint.csv&sp=SCSV&sp=F';
    return await NetworkRouter.getWithCookies(url, {}, session);
  }

  //post job
  static Future submitJob() async{}
}
