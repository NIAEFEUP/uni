import 'dart:async';
import 'dart:collection';

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
import 'package:uni/view/navigation_service.dart';

class SessionProvider extends StateProviderNotifier {
  Session _session = Session();
  List<String> _faculties = [];

  SessionProvider()
      : super(
            dependsOnSession: false,
            cacheDuration: null,
            initialStatus: RequestStatus.none);

  Session get session => _session;

  UnmodifiableListView<String> get faculties =>
      UnmodifiableListView(_faculties);

  @override
  Future<void> loadFromStorage() async {}

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    updateStatus(RequestStatus.successful);
  }

  login(Completer<void> action, String username, String password,
      List<String> faculties, persistentSession) async {
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

        await acceptTermsAndConditions();
        updateStatus(RequestStatus.successful);
      } else {
        final String responseHtml =
            await NetworkRouter.loginInSigarra(username, password, faculties);
        if (isPasswordExpired(responseHtml)) {
          action.completeError(ExpiredCredentialsException());
        } else {
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
      {Completer? action}) async {
    try {
      updateStatus(RequestStatus.busy);
      _session = await NetworkRouter.login(username, password, faculties, true);

      if (session.authenticated) {
        Future.delayed(const Duration(seconds: 20),
            () => {NotificationManager().initializeNotifications()});
        updateStatus(RequestStatus.successful);
        action?.complete();
      } else {
        handleFailedReLogin(action);
      }
    } catch (e) {
      _session = Session(
          studentNumber: username,
          authenticated: false,
          faculties: faculties,
          type: '',
          cookies: '',
          persistentSession: true);

      handleFailedReLogin(action);
    }
  }

  handleFailedReLogin(Completer? action) {
    action?.completeError(RequestStatus.failed);
    if (!session.persistentSession) {
      return NavigationService.logout();
    }
  }
}
