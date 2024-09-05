import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/sigarra/endpoints/oidc.dart' as oidc;
import 'package:uni/sigarra/options.dart';

class FederatedSessionUserInfo {
  FederatedSessionUserInfo(
    UserInfo userInfo,
  )   : username = _extractUsername(userInfo),
        faculties = _extractFaculties(userInfo);

  final String username;
  final List<String> faculties;

  static String _extractUsername(UserInfo userInfo) {
    return userInfo.getTyped<String>('nmec')!;
  }

  static List<String> _extractFaculties(UserInfo userInfo) {
    final faculties = userInfo
        .getTyped<List<dynamic>>('ous')!
        .cast<String>()
        .map((element) => element.toLowerCase())
        .toList();

    return faculties;
  }
}

class FederatedSessionRequest extends SessionRequest {
  FederatedSessionRequest({
    required this.credential,
  });

  final Credential credential;

  @override
  Future<FederatedSession> perform([http.Client? httpClient]) async {
    final userInfo = FederatedSessionUserInfo(await credential.getUserInfo());

    final authorizedClient = credential.createHttpClient(httpClient);
    final cookies = await oidc.getCookies(
      options: BaseRequestOptions(
        client: authorizedClient,
      ),
    );

    return FederatedSession(
      username: userInfo.username,
      faculties: userInfo.faculties,
      cookies: cookies,
      credential: credential,
    );
  }
}
