import 'dart:async';
import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/app_links/uni_app_links.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/federated/client.dart';
import 'package:uni/session/flows/federated/request.dart';

class FederatedSessionInitiator extends SessionInitiator {
  FederatedSessionInitiator({required this.realm, required this.clientId});

  final Uri realm;
  final String clientId;

  Future<T> _handleAuthExceptions<T>(
    Future<T> future, {
    required AuthenticationException onError,
  }) {
    T reportExceptionAndFail<E extends Object>(E error, StackTrace st) {
      unawaited(Sentry.captureException(error, stackTrace: st));
      throw onError;
    }

    return future
        .onError<HttpException>(reportExceptionAndFail)
        .onError<FlutterAppAuthOAuthError>(reportExceptionAndFail)
        .onError<FlutterAppAuthPlatformException>(reportExceptionAndFail)
        .onError<FlutterAppAuthUserCancelledException>(reportExceptionAndFail);
  }

  @override
  Future<FederatedSessionRequest> initiate([http.Client? httpClient]) async {
    httpClient ??= FederatedDefaultClient();

    final appLinks = UniAppLinks();

    final request = AuthorizationTokenRequest(
      clientId,
      appLinks.login.redirectUri.toString(),
      issuer: realm.toString(),
      scopes: [
        'openid',
        'profile',
        'email',
        'offline_access',
        'audience',
        'uporto_data',
      ],
      promptValues: ['login'],
    );

    const appAuth = FlutterAppAuth();

    final tokenResponse = await _handleAuthExceptions(
      appAuth.authorizeAndExchangeCode(request),
      onError: const AuthenticationException(
        'Failed to authenticate with OIDC provider',
      ),
    );

    return FederatedSessionRequest(tokenResponse: tokenResponse);
  }
}
