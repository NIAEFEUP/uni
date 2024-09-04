import 'dart:async';

import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/session/base/initiator.dart';
import 'package:uni/session/base/session.dart';

class SessionProvider extends StateProviderNotifier<Session?> {
  SessionProvider()
      : super(
          cacheDuration: null,
          initialStatus: RequestStatus.none,
          dependsOnSession: false,
        );

  @override
  Future<Session?> loadFromStorage(StateProviders stateProviders) async {
    final session = await PreferencesController.getSavedSession();
    return session;
  }

  @override
  Future<Session?> loadFromRemote(StateProviders stateProviders) async {
    if (state == null) {
      return null;
    }

    final request = state!.createRefreshRequest();
    final newState = await request.perform();

    return newState;
  }

  Future<void> login(
    SessionInitiator initiator, {
    required bool persistentSession,
  }) async {
    final request = await initiator.initiate();
    final session = await request.perform();

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
