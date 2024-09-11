import 'dart:async';

import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/logout/logout_handler.dart';

class AuthenticationSnapshot {
  AuthenticationSnapshot(
    this.session, {
    required Future<void> Function() invalidate,
  }) : _invalidate = invalidate;

  final Session session;
  final Future<void> Function() _invalidate;

  Future<void> invalidate() => _invalidate();
}

abstract class AuthenticationController {
  AuthenticationController({this.logoutHandler});

  Future<AuthenticationSnapshot> get snapshot;

  final LogoutHandler? logoutHandler;

  Future<void> close() async {
    final currentSnapshot = await snapshot;
    final session = currentSnapshot.session;

    return logoutHandler?.close(session);
  }
}
