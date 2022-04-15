import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = NetworkRouter.getBaseUrl('feup') +
        'imp4_impressoes.atribs'; // print page returns 403 on some faculties
    return [url];
  }

  getUserPrintsResponse(Session session) {
    final String url = getEndpoints(session)[0];
    final Map<String, String> query = {'p_codigo': session.studentNumber};
    return NetworkRouter.getWithCookies(url, query, session);
  }
}
