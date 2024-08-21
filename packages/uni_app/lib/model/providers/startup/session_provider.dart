import 'dart:async';

import 'package:logger/logger.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/session/base/request.dart';
import 'package:uni/session/base/session.dart';
import 'package:uni/session/federated/request.dart';
import 'package:uni/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return request.perform();
  }

  static Future<void> _invoke(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      Logger().e('Could not launch $uri');
    }
  }

  Future<void> login(
    SessionRequest request, {
    required bool persistentSession,
  }) async {
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

  Future<void> federatedAuthentication({
    required Future<Uri> onAuthentication,
    required bool persistentSession,
  }) async {
    final issuer = await Issuer.discover(Uri.parse(realm));
    final client = Client(
      issuer,
      clientId,
    );

    final flow = Flow.authorizationCodeWithPKCE(
      client,
      scopes: [
        'openid',
        'profile',
        'email',
        'offline_access',
        'audience',
        'uporto_data',
      ],
    )..redirectUri = Uri.parse('pt.up.fe.ni.uni://auth');

    await _invoke(flow.authenticationUri);
    final uri = await onAuthentication;

    final credential = await flow.callback(uri.queryParameters);

    final request = FederatedSessionRequest(credential: credential);
    await login(request, persistentSession: persistentSession);
  }
}
