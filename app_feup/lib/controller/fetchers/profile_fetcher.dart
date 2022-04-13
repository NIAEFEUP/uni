import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

class ProfileFetcher {
  /// Returns the user's [Profile].
  static Future<Profile> getProfile(Session session) async {
    final url = NetworkRouter.getBaseUrlsFromSession(session)[0] +
        'mob_fest_geral.perfil?';
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_codigo': session.studentNumber}, session);

    if (response.statusCode == 200) {
      return Profile.fromResponse(response);
    }
    return Profile();
  }
}
