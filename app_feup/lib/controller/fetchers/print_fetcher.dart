import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = NetworkRouter.getBaseUrl('feup') +
        'imp4_impressoes.atribs'; // endpoint only available for feup
    return [url];
  }

  getUserPrintsResponse(Session session) {
    final String url = getEndpoints(session)[0];
    final Map<String, String> query = {'p_codigo': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }

  getUserPrintsMovements(Session session) {
    final String url =
        NetworkRouter.getBaseUrl('feup') + 'imp4_impressoes.logs?';
    final Map<String, String> query = {'p_codigo': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }

  getPrintHomePage(Session session) async {
    final url = 'https://print.up.pt/app?service=page/UserSummary';
    return await NetworkRouter.getWithCookies(url, {}, session);
  }
}
