import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:uni/session/base/session.dart';

class SessionSnapshot {
  SessionSnapshot(
    this.session, {
    required Future<void> Function(SessionSnapshot) invalidate,
  }) : _invalidate = invalidate;

  final Session session;
  final Future<void> Function(SessionSnapshot) _invalidate;

  Future<void> invalidate() => _invalidate(this);
}

class SessionFreshnessController {
  SessionFreshnessController(this._session);

  Session _session;

  final Lock _authenticationLock = Lock();
  Future<void>? _nextAuthentication;

  Future<SessionSnapshot> get snapshot async {
    final nextAuthentication = _nextAuthentication;
    if (nextAuthentication != null) {
      await nextAuthentication;
    }

    return SessionSnapshot(
      _session,
      invalidate: (snapshot) => _invalidate(snapshot.session),
    );
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

  Future<void> _reauthenticate() async {
    final refreshRequest = _session.createRefreshRequest();
    _session = await refreshRequest.perform();

    await _authenticationLock.synchronized(() => _nextAuthentication = null);
  }
}
