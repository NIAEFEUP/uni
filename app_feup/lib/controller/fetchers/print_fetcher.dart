import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher {
  static getUserPrintsResponse(Session session) {
    final String url = NetworkRouter.getBaseUrlsFromSession(session)[0] +
        'imp4_impressoes.atribs?';
    final Map<String, String> query = {'p_codigo': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }
}
