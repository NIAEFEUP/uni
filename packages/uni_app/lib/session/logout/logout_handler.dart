import 'dart:async';

import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/flows/credentials/session.dart';
import 'package:uni/session/flows/federated/session.dart';

abstract class LogoutHandler {
  Future<void>? closeCredentialsSession(CredentialsSession session) => null;
  Future<void>? closeFederatedSession(FederatedSession session) => null;

  Future<void>? close(Session session) {
    if (session is FederatedSession) {
      return closeFederatedSession(session);
    } else if (session is CredentialsSession) {
      return closeCredentialsSession(session);
    } else {
      throw Exception('Unknown session type');
    }
  }
}
