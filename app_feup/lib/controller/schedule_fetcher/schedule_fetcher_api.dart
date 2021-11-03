import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_schedule.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

class ScheduleFetcherApi extends ScheduleFetcher {
  @override
  Future<List<Lecture>> getLectures(Store<AppState> store) async {
    final dates = getDates();
    final List<Lecture> lectures = await parseSchedule(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                //ignore: lines_longer_than_80_chars
                '''mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}&pv_semana_ini=${dates.beginWeek}&pv_semana_fim=${dates.endWeek}''',
            {},
            store.state.content['session']));

    return lectures;
  }

  //If developer wants to hardcode lectures for debugging,
  //should call this function in the getLectures function
  List<Lecture> getHardcodedLectures() {
    //Uncomment in order to simulate hardcoded lectures
    return <Lecture>[
      Lecture.fromHtml('SOPE', 'T', 0, '10:00', 4, 'B315', 'JAS', 'MIEIC03'),
      Lecture.fromHtml('SDIS', 'T', 0, '13:00', 4, 'B315', 'PMMS', 'MIEIC03'),
      Lecture.fromHtml('AMAT', 'T', 1, '12:00', 4, 'B315', 'PMMS', 'MIEIC03')
    ];
  }
}
