import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

/// Class for fetching the user's lectures from the faculties' API.
class ScheduleFetcherApi extends ScheduleFetcher {
  /// Fetches the user's lectures from the faculties' API.
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    final dates = getDates();
    final baseUrls =
        NetworkRouter.getBaseUrlsFromSession(store.state.content['session']);
    final responses = [];
    for (var url in baseUrls) {
      final response = await NetworkRouter.getWithCookies(
          url +
              //ignore: lines_longer_than_80_chars
              'mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}',
          {},
          store.state.content['session']);
      responses.add(response);
    }
    return await parseScheduleMultipleRequests(responses);
  }
}
