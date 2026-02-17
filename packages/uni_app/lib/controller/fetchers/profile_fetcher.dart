import 'package:uni/controller/fetchers/courses_fetcher.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_courses.dart';
import 'package:uni/controller/parsers/parser_profile_info.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/session/flows/base/session.dart';

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
    final urlProfile =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'mob_fest_geral.perfil?';
    final responseProfile = await NetworkRouter.getWithCookies(urlProfile, {
      'pv_codigo': session.username,
    }, session);

    if (responseProfile.statusCode != 200) {
      return null;
    }

    final profile = Profile.fromResponse(responseProfile);
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



    final now = DateTime.now();
    final dummy = '${now.year}-${now.month}-${now.day}T${now.hour}:${now.minute}:${now.second}.${now.millisecond}Z'; 
    final urlProfileInfo =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'fest_geral.info_pessoal_view?';
    final responseProfileInfo = await NetworkRouter.getWithCookies(urlProfileInfo, {
      'pv_num_unico': session.username,
      'pv_dummy': dummy}, session);


    final profileInfoAndPrefixes = parseProfileDetails(responseProfileInfo);
    final profileInfo = profileInfoAndPrefixes[0];
    final emailAltPosition = profileInfo.indexOf(profile.emailAlt);
    final addresses = profileInfo.sublist(emailAltPosition + 1);
    final types = profileInfoAndPrefixes[1].sublist(emailAltPosition + 1);
    final addressesAndTypes = List.generate(addresses.length, (i) => [addresses[i], types[i]]);
    final officialAddresses = addressesAndTypes.where((address) => address.length > 1 && address[1].contains('Residência Oficial')).map((address) => address[0]).toList();
    final addressesInClassesTime = addressesAndTypes.where((address) => address.length > 1 && address[1].contains('Residência em tempo de aulas')).map((address) => address[0]).toList();

    profile
      ..sex = profileInfo[1]
      ..birthDate = profileInfo[2]
      ..maritalStatus = profileInfo[3]
      ..fatherName = profileInfo[4]
      ..motherName = profileInfo[5]
      ..nationalities = profileInfo.sublist(6, emailAltPosition - 4)
      ..taxNumber = profileInfo[emailAltPosition - 4]
      ..citizensCard = profileInfo[emailAltPosition - 3]
      ..socialSecurity = profileInfo[emailAltPosition - 2]
      ..officialAddresses = officialAddresses
      ..addressesInClassesTime = addressesInClassesTime;


    return profile;
  }
}
