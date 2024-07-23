import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/session/federated/session.dart';
import 'package:uni/controller/session/request.dart';

class FederatedSessionRequest extends SessionRequest<FederatedSession> {
  FederatedSessionRequest({
    required this.username,
    required this.faculties,
    required this.credential,
  });

  final String username;
  final List<String> faculties;
  final Credential credential;

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

    final cookies = NetworkRouter.extractCookies(response.headers);

    return FederatedSession(
      username: username,
      faculties: faculties,
      cookies: cookies,
      credential: credential,
    );
  }
}
