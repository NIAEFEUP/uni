import 'dart:async';

import 'package:uni/session/base/session.dart';
import 'package:uni/session/credentials/session.dart';
import 'package:uni/session/federated/session.dart';

abstract class LogoutHandler {
  FutureOr<void> closeCredentialsSession(CredentialsSession session) {}
  FutureOr<void> closeFederatedSession(FederatedSession session) {}

  FutureOr<void> close(Session session) {
    if (session is FederatedSession) {
      return closeFederatedSession(session);
    } else if (session is CredentialsSession) {
      return closeCredentialsSession(session);
    } else {
      throw Exception('Unknown session type');
    }
  }
}
