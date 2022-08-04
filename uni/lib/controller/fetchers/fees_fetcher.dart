import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class FeesFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Check balance on all faculties and discard if user is not enrolled
    // Some shared courses (such as L.EIC) do not put fees on both faculties
    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}gpag_ccorrente_geral.conta_corrente_view';
    return [url];
  }

  Future<Response> getUserFeesResponse(Session session) {
    final String url = getEndpoints(session)[0];
    final Map<String, String> query = {'pct_cod': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }
}
