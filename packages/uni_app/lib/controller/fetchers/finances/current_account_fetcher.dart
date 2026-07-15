import 'package:http/http.dart';
import 'package:uni/controller/fetchers/core/session_dependent_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_current_account.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/session/flows/base/session.dart';

class CurrentAccountFetcher implements SessionDependentFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Check balance on all faculties and discard if user is not enrolled
    // Some shared courses (such as L.EIC) do not put fees on both faculties
    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'gpag_ccorrente_geral.conta_corrente_view';
    return [url];
  }

  Future<Response> getUserFeesResponse(Session session) {
    final url = getEndpoints(session)[0];
    final query = {'pct_cod': session.username};
    return NetworkRouter.getWithCookies(url, query, session);
  }

  Future<(List<Unpaid>, List<AccountStatement>)> extractCurrentAccount(
    Session session,
    CurrentAccountParser parser,
  ) async {
    final response = await getUserFeesResponse(session);

    final unpaid = parser.parseUnpaid(response);
    final accountStatement = parser.parseAccountStatement(response);

    return (unpaid, accountStatement);
  }
}
