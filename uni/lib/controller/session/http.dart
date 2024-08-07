import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart' show RetryClient;
import 'package:uni/controller/session/authentication_controller.dart';

class TimeoutClient extends http.BaseClient {
  TimeoutClient(http.Client inner, {required Duration timeout})
      : _inner = inner,
        _timeout = timeout;

  final http.Client _inner;
  final Duration _timeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request).timeout(_timeout);

  @override
  void close() => _inner.close();
}

class CookieClient extends http.BaseClient {
  CookieClient(
    this._inner, {
    required FutureOr<List<Cookie>> Function() getCookies,
  }) : _getCookies = getCookies;

  final http.Client _inner;
  final FutureOr<List<Cookie>> Function() _getCookies;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final sessionCookies = await _getCookies();

    final initialCookies = request.headers[HttpHeaders.cookieHeader];
    final allCookies = [
      if (initialCookies != null) initialCookies,
      ...sessionCookies.map((cookie) => cookie.toString()),
    ].join('; ');

    request.headers[HttpHeaders.cookieHeader] = allCookies;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

class UniClient extends http.BaseClient {
  UniClient(http.Client inner,
      {required AuthenticationController authenticationController})
      : _authenticationController = authenticationController {
    _inner = _createInnerClient(inner);
  }

  static const Duration _timeout = Duration(seconds: 30);
  late final http.Client _inner;

  final AuthenticationController _authenticationController;

  http.Client _createInnerClient(http.Client inner) => RetryClient.withDelays(
        CookieClient(
          TimeoutClient(inner, timeout: _timeout),
          getCookies: () => _authenticationController.session
              .then((session) => session.cookies),
        ),
        [Duration.zero],
        when: (response) => response.statusCode == 403,
        onRetry: (request, response, attempt) =>
            _authenticationController.invalidate(),
      );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request).timeout(_timeout);
    if (response.statusCode == 200) {
      return response;
    }

    // TODO(limwa): check if the condition is correct
    if (response.statusCode == 403) {
      // kill the session aka ulogout the user from the app
      final session = await _authenticationController.session;
      await session.close();
    }

    return Future.error('HTTP Error: ${response.statusCode}');
  }

  @override
  void close() => _inner.close();
}
