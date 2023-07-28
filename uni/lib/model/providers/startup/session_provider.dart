import 'dart:async';

import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_session.dart';
import 'package:uni/model/entities/login_exceptions.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class SessionProvider extends StateProviderNotifier {
  SessionProvider()
      : super(
          dependsOnSession: false,
          cacheDuration: null,
          initialStatus: RequestStatus.none,
        );

  late Session _session;

  Session get session => _session;

  @override
  Future<void> loadFromStorage() async {}

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    updateStatus(RequestStatus.successful);
  }

  void restoreSession(
    String username,
    String password,
    List<String> faculties,
  ) {
    _session = Session(
      faculties: faculties,
      username: username,
      cookies: '',
      persistentSession: true,
    );
  }

  Future<void> postAuthentication(
    String username,
    String password,
    List<String> faculties, {
    required bool persistentSession,
  }) async {
    updateStatus(RequestStatus.busy);

    Session? session;
    try {
      session = await NetworkRouter.login(
        username,
        password,
        faculties,
        persistentSession: persistentSession,
      );
    } catch (e) {
      updateStatus(RequestStatus.failed);
      throw InternetStatusException();
    }

    if (session == null) {
      final responseHtml =
          await NetworkRouter.loginInSigarra(username, password, faculties);

      updateStatus(RequestStatus.failed);

      if (isPasswordExpired(responseHtml)) {
        throw ExpiredCredentialsException();
      } else {
        throw WrongCredentialsException();
      }
    }

    _session = session;

    if (persistentSession) {
      await AppSharedPreferences.savePersistentUserInfo(
        username,
        password,
        faculties,
      );
    }

    Future.delayed(
      const Duration(seconds: 20),
      () => {NotificationManager().initializeNotifications()},
    );

    await acceptTermsAndConditions();
    updateStatus(RequestStatus.successful);
  }
}
