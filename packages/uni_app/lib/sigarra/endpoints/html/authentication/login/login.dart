import 'dart:async';

import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/sigarra/endpoints/html/authentication/login/response.dart';
import 'package:uni/sigarra/options.dart';

class Login {
  const Login();

  Future<LoginResponse> call({
    required String username,
    required String password,
    FacultyRequestOptions? options,
  }) async {
    options = options ?? FacultyRequestOptions();

    final loginUrl = options.baseUrl.resolve('vld_validacao.validacao');

    final response = await options.client.post(
      loginUrl,
      body: {
        'p_user': username,
        'p_pass': password,
      },
    );

    return _parse(response);
  }

  Future<LoginResponse> _parse(http.Response response) async {
    if (response.statusCode != 200) {
      return const LoginFailedResponse(
        reason: LoginFailureReason.serverError,
      );
    }

    final document = html_parser.parse(response.body);

    if (_isSucessfulResponse(document)) {
      return const LoginResponse(success: true);
    }

    final failureReason = _parseFailureReason(document);
    return LoginFailedResponse(reason: failureReason);
  }

  bool _isSucessfulResponse(html.Document document) {
    final refresh = document.head?.querySelector("meta[http-equiv='refresh']");
    return refresh != null;
  }

  LoginFailureReason _parseFailureReason(html.Document document) {
    try {
      final alert = document.body?.querySelector('p.aviso-invalidado')?.text;
      if (alert != null) {
        return _parseFailureReasonFromInvalidatedWarning(alert);
      }

      final error = document.body?.querySelector('p.erro-nota')?.text;
      if (error != null) {
        return _parseFailureReasonFromErrorNote(error);
      }

      throw Exception('Could not find failure reason');
    } catch (err, st) {
      unawaited(
        Sentry.captureException(
          SentryEvent(
            throwable: err,
            request: SentryRequest(
              data: document.outerHtml,
            ),
          ),
          stackTrace: st,
        ),
      );

      return LoginFailureReason.unknown;
    }
  }

  LoginFailureReason _parseFailureReasonFromInvalidatedWarning(String warning) {
    if (warning.contains('expirad')) {
      unawaited(
        Sentry.captureMessage(
          'Invalidated warning: expired credentials -> "$warning"',
        ),
      );
      return LoginFailureReason.expiredCredentials;
    }

    return switch (warning) {
      'O conjunto utilizador/senha não é válido.' =>
        LoginFailureReason.wrongCredentials,
      'A sua conta encontra-se bloqueada.' => LoginFailureReason.blockedAccount,
      _ => throw Exception('Unknown invalidated warning: "$warning"'),
    };
  }

  LoginFailureReason _parseFailureReasonFromErrorNote(String error) {
    if (error.startsWith('Já se encontra autenticado com o utilizador')) {
      return LoginFailureReason.alreadyLoggedIn;
    }

    throw Exception('Unknown error note: "$error"');
  }
}
