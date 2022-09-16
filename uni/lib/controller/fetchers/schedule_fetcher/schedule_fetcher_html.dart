import 'package:http/http.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule_html.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class ScheduleFetcherHtml extends ScheduleFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}hor_geral.estudantes_view')
        .toList();
    return urls;
  }

  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<Lecture>> getLectures(Session session, Profile profile) async {
    final dates = getDates();
    final urls = getEndpoints(session);
    final List<Response> lectureResponses = [];
    for (final course in profile.courses) {
      for (final url in urls) {
        final response = await NetworkRouter.getWithCookies(
            url,
            {
              'pv_fest_id': course.festId.toString(),
              'pv_ano_lectivo': dates.lectiveYear.toString(),
              'p_semana_inicio': dates.beginWeek,
              'p_semana_fim': dates.endWeek
            },
            session);
        lectureResponses.add(response);
      }
    }

    final List<Lecture> lectures = await Future.wait(lectureResponses
            .map((response) => getScheduleFromHtml(response, session)))
        .then((schedules) => schedules.expand((schedule) => schedule).toList());

    lectures.sort((l1, l2) => l1.compare(l2));
    return lectures;
  }
}
