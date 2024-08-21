import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart' show RetryClient;
import 'package:logger/logger.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/session/authentication_controller.dart';
import 'package:uni/session/session.dart';
/*
class AuthenticatedClient extends http.BaseClient {
  AuthenticatedClient(
    http.Client inner, {
    required AuthenticationController authenticationController,
  }) : _authenticationController = authenticationController {
    _innerWithoutReauthentication =
        _createInnerClientWithoutReauthentication(inner);
    _inner = RetryClient.withDelays(
      _innerWithoutReauthentication,
      [Duration.zero],
      when: shouldReauthenticate,
      onRetry: (request, response, attempt) =>
          _authenticationController.invalidate(),
    );
  }

  late final http.Client _inner;
  late final http.Client _innerWithoutReauthentication;

  final AuthenticationController _authenticationController;
  final FutureOr<bool> Function(Session) _shouldInvalidateSession;

  http.Client _createInnerClientWithoutReauthentication(http.Client inner) =>
      CookieClient(
        inner,
        getCookies: () => _authenticationController.session
            .then((session) => session.cookies),
      );

  Future<bool> shouldReauthenticate(http.BaseResponse response) async =>
      response.statusCode == 403 && !await _isUserLoggedIn();

  /// Check if the user is still logged in,
  /// performing a health check on the user's personal page.
  Future<bool> _isUserLoggedIn() async {
    Logger().d('Checking if user is still logged in');

    final session = await _authenticationController.session;

    final url = '${NetworkRouter.getBaseUrl(session.mainFaculty)}'
        'fest_geral.cursos_list?pv_num_unico=${session.username}';

    final response = await _innerWithoutReauthentication.get(url.toUri());
    return response.statusCode == 200;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);
    if (response.statusCode == 200) {
      return response;
    }

    // If it should still be reauthenticated, even after the retry,
    // then the session should be invalidated.
    if (await shouldReauthenticate(response)) {
      // TODO(limwa): maybe throw exception instead?
      final session = await _authenticationController.session;
      await session.close();
      // NavigationService.logoutAndPopHistory();
    }

    return Future.error('HTTP Error: ${response.statusCode}');
  }

  @override
  void close() => _inner.close();
}
*/
