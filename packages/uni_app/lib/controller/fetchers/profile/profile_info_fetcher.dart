import 'package:uni/controller/fetchers/core/session_dependent_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_profile_info.dart';
import 'package:uni/model/entities/profile_info.dart';
import 'package:uni/session/flows/base/session.dart';

class ProfileInfoFetcher implements SessionDependentFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = NetworkRouter.getBaseUrlsFromSession(
      session,
    )[0]; // user profile is the same on all faculties
    return [url];
  }

  /// Returns the user's [ProfileInfo].
  static Future<ProfileInfo?> fetchProfileInfo(Session session) async {
    final now = DateTime.now();
    final dummy =
        '${now.year}-${now.month}-${now.day}T${now.hour}:${now.minute}:${now.second}.${now.millisecond}Z';
    final urlProfileInfo =
        '${NetworkRouter.getBaseUrlsFromSession(session, languageSensitive: true)[0]}'
        'fest_geral.info_pessoal_view?';
    final responseProfileInfo = await NetworkRouter.getWithCookies(
      urlProfileInfo,
      {'pv_num_unico': session.username, 'pv_dummy': dummy},
      session,
    );

    if (responseProfileInfo.statusCode != 200) {
      return null;
    }
    final data = parseProfileDetails(responseProfileInfo);

    final profileInfo = ProfileInfo.fromList(data);

    return profileInfo;
  }
}
