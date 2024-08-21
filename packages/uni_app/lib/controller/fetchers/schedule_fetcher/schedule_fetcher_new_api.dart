import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/schedule/new_api/parser.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class ScheduleFetcherNewApi extends ScheduleFetcher {
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
    final endpoints = getEndpoints(session);
    final lectiveYear = getLectiveYear(DateTime.now());

    final futures = endpoints.map((baseUrl) async {
      final scheduleResponse = await NetworkRouter.getWithCookies(
        baseUrl,
        {
          'pv_num_unico': session.username,
          'pv_ano_lectivo': lectiveYear.toString(),
          'pv_periodos': '1',
        },
        session,
      );

      final scheduleApiUrl = getScheduleApiUrlFromHtml(scheduleResponse);

      final scheduleApiResponse = await NetworkRouter.getWithCookies(
        scheduleApiUrl,
        {},
        session,
      );

      return getLecturesFromApiResponse(scheduleApiResponse);
    });

    final results = await Future.wait(futures);

    // TODO(limwa,#1281): Check if handling of lectures in both faculties is correct.
    final lectures = results.expand((element) => element).toList()
      ..sort((l1, l2) => l1.compare(l2));

    return lectures;
  }
}
