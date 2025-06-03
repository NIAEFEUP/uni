import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/http/client/bearer.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/federated/client.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/sigarra/endpoints/oidc/oidc.dart';
import 'package:uni/sigarra/endpoints/oidc/token/response.dart';
import 'package:uni/sigarra/options.dart';

class FederatedCredential {
  FederatedCredential(this.tokenResponse);

  final AuthorizationTokenResponse tokenResponse;

  String? get accessToken => tokenResponse.accessToken;

  http.Client createAuthenticatedClient(http.Client inner) {
    final token = accessToken;
    if (token == null) {
      throw const AuthenticationException('No access token');
    }

    return BearerClient(inner, token: () => token);
  }

  Future<Map<String, dynamic>> getUserInfo([http.Client? httpClient]) async {
    httpClient ??= http.Client();

    final token = accessToken;
    if (token == null) {
      throw const AuthenticationException('No access token');
    }

    final issuer =
        tokenResponse.tokenAdditionalParameters?['issuer'] as String?;
    if (issuer == null) {
      throw const AuthenticationException('No issuer information');
    }

    final userInfoEndpoint =
        Uri.parse(issuer).replace(path: '/userinfo').toString();
    final response = await httpClient.get(
      Uri.parse(userInfoEndpoint),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw const AuthenticationException('Failed to get user info');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class FederatedSessionUserInfo {
  FederatedSessionUserInfo(Map<String, dynamic> userInfo)
    : username = _extractUsername(userInfo),
      faculties = _extractFaculties(userInfo);

  final String username;
  final List<String> faculties;

  static String _extractUsername(Map<String, dynamic> userInfo) {
    return userInfo['nmec'] as String;
  }

  static List<String> _extractFaculties(Map<String, dynamic> userInfo) {
    final faculties =
        (userInfo['ous'] as List<dynamic>)
            .cast<String>()
            .map((element) => element.toLowerCase())
            .toList();

    return faculties;
  }
}

class FederatedSessionRequest extends SessionRequest {
  FederatedSessionRequest({required AuthorizationTokenResponse tokenResponse})
    : credential = FederatedCredential(tokenResponse);

  final FederatedCredential credential;

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

    final authorizedClient = credential.createAuthenticatedClient(httpClient);

    final oidc = SigarraOidc();
    final response = await oidc
        .token(options: SigarraRequestOptions(client: authorizedClient))
        .call()
        .onError<OpenIdException>(_reportExceptionAndFail)
        .onError<HttpRequestException>(_reportExceptionAndFail);

    if (!response.success) {
      throw const AuthenticationException('Failed to get OIDC token');
    }

    final userInfo = FederatedSessionUserInfo(
      await credential.getUserInfo(httpClient),
    );
    final successfulResponse = response.asSuccessful();

    final tempSession = FederatedSession(
      username: userInfo.username,
      faculties: userInfo.faculties,
      cookies: successfulResponse.cookies,
      tokenResponse: credential.tokenResponse,
    );

    final faculties = await getStudentFaculties(tempSession, httpClient);

    return FederatedSession(
      username: userInfo.username,
      faculties: faculties,
      cookies: successfulResponse.cookies,
      tokenResponse: credential.tokenResponse,
    );
  }
}
