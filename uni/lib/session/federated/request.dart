import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:uni/session/federated/session.dart';
import 'package:uni/session/request.dart';
import 'package:uni/sigarra/endpoints/oidc.dart' as oidc;
import 'package:uni/sigarra/options.dart';

class FederatedSessionRequest extends SessionRequest {
  FederatedSessionRequest({
    required this.credential,
  });

  final Credential credential;

  String _getUsername(UserInfo userInfo) {
    return userInfo.getTyped<String>('nmec')!;
  }

  List<String> _getFaculties(UserInfo userInfo) {
    final faculties = userInfo
        .getTyped<List<dynamic>>('ous')!
        .cast<String>()
        .map((element) => element.toLowerCase())
        .toList();

    return faculties;
  }

  @override
  Future<FederatedSession> perform([
    http.Client? client,
  ]) async {
    final userInfo = await credential.getUserInfo();
    final username = _getUsername(userInfo);
    final faculties = _getFaculties(userInfo);

    final authorizedClient = credential.createHttpClient(client);
    final cookies = await oidc.getCookies(
      options: BaseRequestOptions(
        client: authorizedClient,
      ),
    );

    return FederatedSession(
      username: username,
      cookies: cookies,
      faculties: faculties,
      credential: credential,
    );
  }
}
