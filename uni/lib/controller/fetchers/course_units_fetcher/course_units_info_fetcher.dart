import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_unit_info.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/session.dart';

class CourseUnitsInfoFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // if course unit is not from the main faculty, Sigarra redirects
    final url =
        '${NetworkRouter.getBaseUrl(session.faculties[0])}ucurr_geral.ficha_uc_view';
    return [url];
  }

  Future<CourseUnitSheet> fetchCourseUnitSheet(
      Session session, int occurrId) async {
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_ocorrencia_id': occurrId.toString()}, session);
    return parseCourseUnitSheet(response);
  }

  Future<List<CourseUnitClass>> fetchCourseUnitClasses(
      Session session, int occurrId) async {
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_ocorrencia_id': occurrId.toString()}, session);
    return parseCourseUnitClasses(response);
  }
}
