import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/session/federated/session.dart';
import 'package:uni/controller/session/request.dart';

class FederatedSessionRequest extends SessionRequest {
  FederatedSessionRequest({
    required this.credential,
  });

  final Credential credential;

  Future<String> _getUsername() async {
    final userInfo = await credential.getUserInfo();
    return userInfo.getTyped<String>('nmec')!;
  }

  Future<List<String>> _getFaculties() async {
    final userInfo = await credential.getUserInfo();
    final faculties = userInfo
        .getTyped<List<dynamic>>('ous')!
        .cast<String>()
        .map((element) => element.toLowerCase())
        .toList();

    return faculties;
  }

  @override
  Future<FederatedSession> perform() async {
    final authorizedClient = credential.createHttpClient();

    final sigarraTokenEndpoint =
        Uri.parse('https://sigarra.up.pt/auth/oidc/token');

    final response = await authorizedClient.get(
      sigarraTokenEndpoint,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      Logger().e('Failed to get token from SIGARRA');
      throw Exception('Failed to get token from SIGARRA');
    }

    // TODO (limwa): Is checking the result necessary?
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['result'] != 'OK') {
      Logger().e('Failed to get token from SIGARRA');
      throw Exception('Failed to get token from SIGARRA');
    }

    final cookies = NetworkRouter.extractCookies(response);

    return FederatedSession(
      username: await _getUsername(),
      faculties: await _getFaculties(),
      cookies: cookies,
      credential: credential,
    );
  }
}
