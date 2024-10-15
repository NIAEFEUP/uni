import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/schedule/new_api/parser.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/session/flows/base/session.dart';

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
  Future<List<Lecture>> getLectures(Session session) async {
    final url = getEndpoints(session)[0];
    final lectiveYear = getLectiveYear(DateTime.now());

    final scheduleResponse = await NetworkRouter.getWithCookies(
      url,
      {
        'pv_num_unico': session.username,
        'pv_ano_lectivo': lectiveYear.toString(),
        'pv_periodos': '1',
      },
      session,
    );

    final scheduleApiUrl = getScheduleApiUrlFromHtml(scheduleResponse);

    if (scheduleApiUrl == null) {
      return <Lecture>[];
    }

    final scheduleApiResponse = await NetworkRouter.getWithCookies(
      scheduleApiUrl,
      {},
      session,
    );

    final results = getLecturesFromApiResponse(scheduleApiResponse);

    // TODO(limwa,#1281): Check if handling of lectures in both faculties is correct.
    final lectures = results..sort((l1, l2) => l1.compare(l2));

    return lectures;
  }
}
