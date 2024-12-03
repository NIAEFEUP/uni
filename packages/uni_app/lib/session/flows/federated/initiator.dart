import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/federated/client.dart';
import 'package:uni/session/flows/federated/request.dart';

class FederatedSessionInitiator extends SessionInitiator {
  FederatedSessionInitiator({
    required this.realm,
    required this.clientId,
    required this.performAuthentication,
  });

  final Uri realm;
  final String clientId;
  final Future<Uri> Function(Flow flow) performAuthentication;

  Future<T> _handleOpenIdExceptions<T>(
    Future<T> future, {
    required AuthenticationException onError,
  }) {
    T reportExceptionAndFail<E extends Object>(E error, StackTrace st) {
      unawaited(Sentry.captureException(error, stackTrace: st));
      throw onError;
    }

    return future
        .onError<HttpRequestException>(reportExceptionAndFail)
        .onError<OpenIdException>(reportExceptionAndFail);
  }

  @override
  Future<FederatedSessionRequest> initiate([http.Client? httpClient]) async {
    httpClient ??= FederatedDefaultClient();

    final issuer = await _handleOpenIdExceptions(
      Issuer.discover(realm, httpClient: httpClient),
      onError: const AuthenticationException('Failed to discover OIDC issuer'),
    );

    final client = Client(issuer, clientId, httpClient: httpClient);
    final flow = Flow.authorizationCodeWithPKCE(
      client,
      scopes: [
        'openid',
        'profile',
        'email',
        'offline_access',
        'audience',
        'uporto_data',
      ],
    );

    final uri = await performAuthentication(flow);
    final credential = await _handleOpenIdExceptions(
      flow.callback(uri.queryParameters),
      onError: const AuthenticationException('Failed to execute flow callback'),
    );

    return FederatedSessionRequest(credential: credential);
  }
}
