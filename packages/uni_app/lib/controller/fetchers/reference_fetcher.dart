import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/session/flows/base/session.dart';

class ReferenceFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final baseUrls = NetworkRouter.getBaseUrlsFromSession(session) +
        [NetworkRouter.getBaseUrl('sasup')];
    final urls = baseUrls
        .map((url) => '${url}gpag_ccorrente_geral.conta_corrente_view')
        .toList();
    return urls;
  }

  Future<Response> getUserReferenceResponse(Session session) {
    final urls = getEndpoints(session);
    final url = urls[0];
    final query = {'pct_cod': session.username};
    return NetworkRouter.getWithCookies(url, query, session);
  }
}
