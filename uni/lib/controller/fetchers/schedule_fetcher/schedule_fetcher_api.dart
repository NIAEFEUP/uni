import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the user's lectures from the faculties' API.
class ScheduleFetcherApi extends ScheduleFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}mob_hor_geral.estudante')
        .toList();
    return urls;
  }

  /// Fetches the user's lectures from the faculties' API.
  @override
  Future<List<Lecture>> getLectures(Session session, Profile profile) async {
    final blocks = getBlocks(getWeekStartEndDates());

    final urls = getEndpoints(session);
    final responses = <Tuple2<Tuple2<DateTime, DateTime>, Response>>[];
    for (final url in urls) {
      final res = blocks.map(
        (block) => NetworkRouter.getWithCookies(
          url,
          {
            'pv_codigo': session.username,
            'pv_semana_ini': toSigarraDate(block.item1),
            'pv_semana_fim': toSigarraDate(block.item2),
          },
          session,
        ).then((value) => Tuple2(block, value)),
      );

      responses.addAll(await Future.wait(res));
    }

    Logger().d('Fetched $responses schedules');
    return parseScheduleMultipleRequests(responses);
  }
}
