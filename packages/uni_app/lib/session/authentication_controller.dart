import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:uni/session/session.dart';

class AuthenticationSnapshot {
  AuthenticationSnapshot(
    this.session, {
    required void Function(AuthenticationSnapshot snapshot) onInvalidate,
  }) : _onInvalidate = onInvalidate;

  final Session session;
  final FutureOr<void> Function(AuthenticationSnapshot) _onInvalidate;

  FutureOr<void> invalidate() => _onInvalidate(this);
}

class AuthenticationController {
  AuthenticationController(this._session);

  Session _session;

  final Lock _authenticationLock = Lock();
  Future<void>? _nextAuthentication;

  Future<AuthenticationSnapshot> get snapshot async {
    final nextAuthentication = _nextAuthentication;
    if (nextAuthentication != null) {
      await nextAuthentication;
    }

    return AuthenticationSnapshot(
      _session,
      onInvalidate: (snapshot) => _invalidate(snapshot.session),
    );
  }

  Future<void> _reauthenticate() async {
    final refreshRequest = _session.createRefreshRequest();
    _session = await refreshRequest.perform();

    await _authenticationLock.synchronized(() => _nextAuthentication = null);
  }

  Future<void> _invalidate(Session session) async {
    // This check is intentionally used twice to avoid unnecessary lock
    // acquisitions.
    if (_nextAuthentication != null || _session != session) {
      return;
    }

    await _authenticationLock.synchronized(() {
      if (_nextAuthentication != null || _session != session) {
        return;
      }

      _nextAuthentication = _reauthenticate();
    });
  }
}
