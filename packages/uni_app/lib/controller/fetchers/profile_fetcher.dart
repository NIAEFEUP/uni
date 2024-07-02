import 'package:uni/controller/fetchers/courses_fetcher.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_courses.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

class ProfileFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = NetworkRouter.getBaseUrlsFromSession(
      session,
    )[0]; // user profile is the same on all faculties
    return [url];
  }

  /// Returns the user's [Profile].
  static Future<Profile?> fetchProfile(Session session) async {
    final url = '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'mob_fest_geral.perfil?';
    final response = await NetworkRouter.getWithCookies(
      url,
      {'pv_codigo': session.username},
      session,
    );

    if (response.statusCode != 200) {
      return null;
    }

    final profile = Profile.fromResponse(response);
    final coursesResponses = await Future.wait(
      CoursesFetcher().getCoursesListResponses(session),
    );
    final courses = parseMultipleCourses(coursesResponses);

    for (final course in courses) {
      if (profile.courses
          .map((c) => c.festId)
          .toList()
          .contains(course.festId)) {
        profile.courses.where((c) => c.festId == course.festId).first.state ??=
            course.state;
        continue;
      }
      profile.courses.add(course);
    }

    return profile;
  }
}
