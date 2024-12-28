import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/federated/client.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/sigarra/endpoints/oidc/oidc.dart';
import 'package:uni/sigarra/endpoints/oidc/token/response.dart';
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

  TokenFailedResponse _reportExceptionAndFail<E extends Object>(
    E error,
    StackTrace st,
  ) {
    unawaited(Sentry.captureException(error, stackTrace: st));
    return const TokenFailedResponse();
  }

  @override
  Future<FederatedSession> perform([http.Client? httpClient]) async {
    httpClient ??= FederatedDefaultClient();

    final authorizedClient = credential.createHttpClient(httpClient);

    final oidc = SigarraOidc();
    final response = await oidc
        .token(options: SigarraRequestOptions(client: authorizedClient))
        .call()
        .onError<OpenIdException>(_reportExceptionAndFail)
        .onError<HttpRequestException>(_reportExceptionAndFail);

    if (!response.success) {
      throw const AuthenticationException('Failed to get OIDC token');
    }

    final userInfo = FederatedSessionUserInfo(await credential.getUserInfo());
    final successfulResponse = response.asSuccessful();

    final tempSession = FederatedSession(
      username: userInfo.username,
      faculties: userInfo.faculties,
      cookies: successfulResponse.cookies,
      credential: credential,
    );

    final faculties = await getStudentFaculties(tempSession, httpClient);

    return FederatedSession(
      username: userInfo.username,
      faculties: faculties,
      cookies: successfulResponse.cookies,
      credential: credential,
    );
  }
}
