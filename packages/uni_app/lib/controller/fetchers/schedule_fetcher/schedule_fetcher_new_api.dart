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
    final futures = <Future<List<Lecture>>>[];

    for (final baseUrl in endpoints) {
      final future = Future(() async {
        final scheduleRequest = await NetworkRouter.getWithCookies(
          baseUrl,
          {
            'pv_num_unico': session.username,
          },
          session,
        );

        final scheduleApiUrl = getScheduleApiUrlFromHtml(scheduleRequest);

        final scheduleApiRequest = await NetworkRouter.getWithCookies(
          scheduleApiUrl,
          {},
          session,
        );

        return getLecturesFromApiResponse(scheduleApiRequest);
      });

      futures.add(future);
    }

    final results = await Future.wait(futures);

    final lectures = results.expand((element) => element).toList()
      ..sort((l1, l2) => l1.compare(l2));

    return lectures;
  }
}
