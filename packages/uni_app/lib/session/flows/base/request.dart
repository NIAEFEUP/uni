import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/base/session.dart';

/// In the authentication flow, a [SessionRequest] is the component responsible
/// for performing the actual authentication of the user. A [SessionRequest]
/// can be created by an [SessionInitiator] or with the
/// [Session.createRefreshRequest] method.
///
/// If the authentication is unsuccessful, the [SessionRequest] will throw an
/// [AuthenticationException].
abstract class SessionRequest {
  /// Performs the authentication request.
  ///
  /// If the authentication fails, the method will throw an
  /// [AuthenticationException].
  FutureOr<Session> perform([http.Client? httpClient]);
}
