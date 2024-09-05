import 'package:uni/session/flows/base/session.dart';

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
  Future<AuthenticationSnapshot> get snapshot;
}
