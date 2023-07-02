import 'dart:async';
import 'dart:collection';

import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_session.dart';
import 'package:uni/model/entities/login_exceptions.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class SessionProvider extends StateProviderNotifier {
  Session _session = Session();
  List<String> _faculties = [];

  Session get session => _session;

  UnmodifiableListView<String> get faculties =>
      UnmodifiableListView(_faculties);

  login(
      Completer<void> action,
      String username,
      String password,
      List<String> faculties,
      StateProviders stateProviders,
      persistentSession,
      usernameController,
      passwordController) async {
    try {
      updateStatus(RequestStatus.busy);

      _faculties = faculties;
      _session = await NetworkRouter.login(
          username, password, faculties, persistentSession);

      if (_session.authenticated) {
        if (persistentSession) {
          await AppSharedPreferences.savePersistentUserInfo(
              username, password, faculties);
        }
        Future.delayed(const Duration(seconds: 20),
            () => {NotificationManager().initializeNotifications()});

        loadLocalUserInfoToState(stateProviders, skipDatabaseLookup: true);
        await loadRemoteUserInfoToState(stateProviders);

        usernameController.clear();
        passwordController.clear();
        await acceptTermsAndConditions();

        updateStatus(RequestStatus.successful);
      } else {
        final String responseHtml =
            await NetworkRouter.loginInSigarra(username, password, faculties);
        if (isPasswordExpired(responseHtml)) {
          action.completeError(ExpiredCredentialsException());
        }else{
          action.completeError(WrongCredentialsException());
        }
        updateStatus(RequestStatus.failed);
      }
    } catch (e) {
      // No internet connection or server down
      action.completeError(InternetStatusException());
      updateStatus(RequestStatus.failed);
    }

    notifyListeners();
    action.complete();
  }

  reLogin(String username, String password, List<String> faculties,
      StateProviders stateProviders,
      {Completer? action}) async {
    try {
      loadLocalUserInfoToState(stateProviders);
      updateStatus(RequestStatus.busy);
      _session = await NetworkRouter.login(username, password, faculties, true);
      notifyListeners();

      if (session.authenticated) {
        await loadRemoteUserInfoToState(stateProviders);
        Future.delayed(const Duration(seconds: 20),
            () => {NotificationManager().initializeNotifications()});
        updateStatus(RequestStatus.successful);
        action?.complete();
      } else {
        failRelogin(action);
      }
    } catch (e) {
      _session = Session(
          studentNumber: username,
          authenticated: false,
          faculties: faculties,
          type: '',
          cookies: '',
          persistentSession: true);

      failRelogin(action);
    }
  }

  void failRelogin(Completer? action) {
    notifyListeners();
    updateStatus(RequestStatus.failed);
    action?.completeError(RequestStatus.failed);
    NetworkRouter.onReloginFail();
  }
}
