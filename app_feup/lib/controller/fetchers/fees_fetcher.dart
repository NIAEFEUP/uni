import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class FeesFetcher {
  static Future<Response> getUserFeesResponse(Session session) {
    final String url = NetworkRouter.getBaseUrlsFromSession(session)[0] +
        'gpag_ccorrente_geral.conta_corrente_view?';
    final Map<String, String> query = {'pct_cod': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }
}
