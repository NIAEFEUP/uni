import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/session/authentication_controller.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/logout/uni_logout_handler.dart';

final sessionProvider = AsyncNotifierProvider<SessionProvider, Session?>(
  SessionProvider.new,
);

class SessionProvider extends CachedAsyncNotifier<Session?> {
  @override
  Duration? get cacheDuration => null;

  AuthenticationController get controller =>
      NetworkRouter.authenticationController!;

  void _initController(Session session) {
    NetworkRouter.authenticationController = AuthenticationController(
      session,
      logoutHandler: UniLogoutHandler(),
    );
  }

  @override
  Future<Session?> loadFromStorage() async {
    final session = await PreferencesController.getSavedSession();
    if (session != null) {
      _initController(session);
    }

    return session;
  }

  @override
  Future<Session?> loadFromRemote() async {
    if (state.value == null) {
      return null;
    }

    final oldSnapshot = await controller.snapshot;
    await oldSnapshot.invalidate();

    final newSnapshot = await controller.snapshot;
    final newSession = newSnapshot.session;

    if (await PreferencesController.isSessionPersistent()) {
      await PreferencesController.saveSession(newSession);
    }

    return newSession;
  }

  Future<void> login(
    SessionInitiator initiator, {
    required bool persistentSession,
  }) async {
    final request = await initiator.initiate();
    final session = await request.perform();

    _initController(session);
    updateState(session);

    if (persistentSession) {
      await PreferencesController.saveSession(session);
    }

    Future.delayed(
      const Duration(seconds: 20),
      () => {NotificationManager().initializeNotifications()},
    );

    await acceptTermsAndConditions();
  }
}
