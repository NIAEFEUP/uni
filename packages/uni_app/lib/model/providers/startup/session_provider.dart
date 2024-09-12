import 'dart:async';

import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/session/authentication_controller.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/logout/uni_logout_handler.dart';

class SessionProvider extends StateProviderNotifier<Session?> {
  SessionProvider()
      : super(
          cacheDuration: null,
          initialStatus: RequestStatus.none,
          dependsOnSession: false,
        );

  AuthenticationController get controller =>
      NetworkRouter.authenticationController!;

  void initController(Session session) {
    NetworkRouter.authenticationController = AuthenticationController(
      session,
      logoutHandler: UniLogoutHandler(),
    );
  }

  @override
  Future<Session?> loadFromStorage(StateProviders stateProviders) async {
    final session = await PreferencesController.getSavedSession();
    if (session != null) {
      initController(session);
    }

    return session;
  }

  @override
  Future<Session?> loadFromRemote(StateProviders stateProviders) async {
    if (state == null) {
      return null;
    }

    final oldSnapshot = await controller.snapshot;
    await oldSnapshot.invalidate();

    final newSnapshot = await controller.snapshot;
    final newState = newSnapshot.session;

    if (await PreferencesController.isSessionPersistent()) {
      await PreferencesController.saveSession(newSnapshot.session);
    }

    return newState;
  }

  Future<void> login(
    SessionInitiator initiator, {
    required bool persistentSession,
  }) async {
    final request = await initiator.initiate();
    final session = await request.perform();

    initController(session);
    setState(session);

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
