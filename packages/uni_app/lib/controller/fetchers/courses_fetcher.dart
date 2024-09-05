import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/session/flows/base/session.dart';

/// Returns the user's current list of [CourseUnit].
class CoursesFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}fest_geral.cursos_list?')
        .toList();
    return urls;
  }

  List<Future<Response>> getCoursesListResponses(Session session) {
    final urls = getEndpoints(session);
    return urls
        .map(
          (url) => NetworkRouter.getWithCookies(
            url,
            {'pv_num_unico': session.username},
            session,
          ),
        )
        .toList();
  }
}
