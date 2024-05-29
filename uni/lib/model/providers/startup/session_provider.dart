import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_session.dart';
import 'package:uni/model/entities/login_exceptions.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/locale_notifier.dart';

class SessionProvider extends StateProviderNotifier<Session> {
  SessionProvider()
      : super(
          cacheDuration: null,
          initialStatus: RequestStatus.none,
          dependsOnSession: false,
        );

  @override
  Future<Session> loadFromStorage(StateProviders stateProviders) async {
    final userPersistentInfo =
        await PreferencesController.getPersistentUserInfo();
    final faculties = PreferencesController.getUserFaculties();

    if (userPersistentInfo == null) {
      return Session(username: '', cookies: '', faculties: faculties);
    }

    return Session(
      faculties: faculties,
      username: userPersistentInfo.item1,
      cookies: '',
      persistentSession: true,
    );
  }

  @override
  Future<Session> loadFromRemote(StateProviders stateProviders) async {
    return state!;
  }

  Future<void> postAuthentication(
    BuildContext context,
    String username,
    String password, {
    required bool persistentSession,
  }) async {
    final locale =
        Provider.of<LocaleNotifier>(context, listen: false).getLocale();
    Session? session;
    List<String> faculties;

    try {
      // We need to login to fetch the faculties, so perform a temporary login.
      final tempSession = await NetworkRouter.login(
        username,
        password,
        ['feup'],
        persistentSession: false,
        ignoreCached: true,
      );
      faculties = await getStudentFaculties(tempSession!);

      // Now get the session with the correct faculties.
      session = await NetworkRouter.login(
        username,
        password,
        faculties,
        persistentSession: persistentSession,
        ignoreCached: true,
      );
    } catch (e) {
      throw InternetStatusException(locale);
    }

    if (session == null) {
      // Get the fail reason.
      final responseHtml =
          await NetworkRouter.loginInSigarra(username, password, ['feup']);

      if (isPasswordExpired(responseHtml) && context.mounted) {
        throw ExpiredCredentialsException();
      } else {
        throw WrongCredentialsException(
          locale,
        );
      }
    }

    setState(session);

    if (persistentSession) {
      await PreferencesController.savePersistentUserInfo(
        session.username,
        password,
        faculties,
      );
    }

    Future.delayed(
      const Duration(seconds: 20),
      () => {NotificationManager().initializeNotifications()},
    );

    await acceptTermsAndConditions();
  }
}
