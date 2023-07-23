import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/courses_fetcher.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_courses.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

class ProfileFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = NetworkRouter.getBaseUrlsFromSession(
        session)[0]; // user profile is the same on all faculties
    return [url];
  }

  /// Returns the user's [Profile].
  static Future<Profile> getProfile(Session session) async {
    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}mob_fest_geral.perfil?';
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_codigo': session.username}, session);

    if (response.statusCode == 200) {
      final Profile profile = Profile.fromResponse(response);
      try {
        final List<Future<Response>> coursesResponses =
            CoursesFetcher().getCoursesListResponses(session);
        final List<Course> courses =
            parseMultipleCourses(await Future.wait(coursesResponses));
        for (Course course in courses) {
          if (profile.courses
              .map((c) => c.festId)
              .toList()
              .contains(course.festId)) {
            final Course matchingCourse =
                profile.courses.where((c) => c.festId == course.festId).first;
            matchingCourse.state ??= course.state;
            continue;
          }
          profile.courses.add(course);
        }
      } catch (e) {
        Logger().e('Failed to get user courses via scrapping: $e');
      }
      return profile;
    }
    return Profile();
  }
}
