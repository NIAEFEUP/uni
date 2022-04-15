import 'package:redux/redux.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the user's lectures from the faculties' API.
class ScheduleFetcherApi extends ScheduleFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => url + 'mob_hor_geral.estudante')
        .toList();
    return urls;
  }

  /// Fetches the user's lectures from the faculties' API.
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    final dates = getDates();
    final session = store.state.content['session'];
    final urls = getEndpoints(session);
    final responses = [];
    for (var url in urls) {
      final response = await NetworkRouter.getWithCookies(
          url,
          {
            'pv_codigo': session.studentNumber,
            'pv_semana_ini': dates.beginWeek,
            'pv_semana_fim': dates.endWeek
          },
          session);
      responses.add(response);
    }
    return await parseScheduleMultipleRequests(responses);
  }
}
