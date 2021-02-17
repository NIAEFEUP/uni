import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

class ScheduleFetcherApi extends ScheduleFetcher {
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    var date = DateTime.now();
    final String beginWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
    date = date.add(Duration(days: 6));

    final String endWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
    final List<Lecture> lectures = await parseSchedule(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                //ignore: lines_longer_than_80_chars
                '''mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}&pv_semana_ini=$beginWeek&pv_semana_fim=$endWeek''',
            {},
            store.state.content['session']));
    return lectures;
  }
}
