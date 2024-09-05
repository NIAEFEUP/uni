import 'package:synchronized/synchronized.dart';
import 'package:uni/session/controller/authentication_controller.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/logout/logout_handler.dart';

class RefreshingAuthenticationController extends AuthenticationController {
  RefreshingAuthenticationController(
    Session initialSession, {
    this.logoutHandler,
  }) : _currentSession = initialSession;

  final LogoutHandler? logoutHandler;
  final Lock _authenticationLock = Lock();

  Future<void>? _nextAuthentication;
  Session _currentSession;

  @override
  Future<AuthenticationSnapshot> get snapshot async {
    final nextAuthentication = _nextAuthentication;
    if (nextAuthentication != null) {
      await nextAuthentication;
    }

    final snapshottedSession = _currentSession;
    return AuthenticationSnapshot(
      snapshottedSession,
      invalidate: () => _invalidate(snapshottedSession),
    );
  }

  Future<void> invalidate() async {
    final currentSnapshot = await snapshot;
    await currentSnapshot.invalidate();
  }

  bool _shouldInvalidate(Session session) {
    // We invalidate if the is not an invalidation in progress already
    // and the session is the same as the current one.
    return _nextAuthentication == null && _currentSession == session;
  }

  Future<void> _invalidate(Session session) async {
    // This check is intentionally used twice to avoid unnecessary lock
    // acquisitions.
    if (!_shouldInvalidate(session)) {
      return;
    }

    await _authenticationLock.synchronized(() {
      // After the lock is acquired, the condition could have changed if
      // another thread has already invalidated the session.
      if (!_shouldInvalidate(session)) {
        return;
      }

      _nextAuthentication = _reauthenticate();
    });
  }

  Future<void> _reauthenticate() async {
    try {
      final request = _currentSession.createRefreshRequest();
      _currentSession = await request.perform();

      // If the reauthentication is successful, we indicate that the
      // invalidation is no longer in progress and another one can be
      // performed.
      await _authenticationLock.synchronized(() => _nextAuthentication = null);
    } on AuthenticationException {
      await logoutHandler?.close(_currentSession);
      rethrow;
    } catch (_) {}
  }
}
