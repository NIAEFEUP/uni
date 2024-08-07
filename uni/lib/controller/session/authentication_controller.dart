import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/session/session.dart';

class AuthenticationController {
  AuthenticationController(this._session);

  Session _session;

  final Lock _authenticationLock = Lock();
  Future<void>? nextAuthentication;

  Future<Session> get session async {
    final nextAuthentication = this.nextAuthentication;
    if (nextAuthentication != null) {
      await nextAuthentication;
    }

    return _session;
  }

  Future<void> _reauthenticate() async {
    final refreshRequest = _session.createRefreshRequest();
    _session = await refreshRequest.perform();

    await _authenticationLock.synchronized(() => nextAuthentication = null);
  }

  Future<void> invalidate() async {
    // This check is used to avoid unnecessary lock acquisitions
    if (nextAuthentication != null) {
      return;
    }

    // A lock is needed for nextAuthentication because ??= is not atomic
    await _authenticationLock
        .synchronized(() => nextAuthentication ??= _reauthenticate());
  }
}
