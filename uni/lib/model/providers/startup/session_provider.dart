import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:openid_client/openid_client.dart';
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
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> _invoke(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      Logger().e('Could not launch $uri');
    }
  }

  Future<void> postAuthentication(
    material.BuildContext context,
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
    } catch (_) {
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

  late Flow? _flow;
  late material.BuildContext? context;
  bool _persistentSession = false;

  Future<void> federatedAuthentication(
    material.BuildContext ctx, {
    required bool persistentSession,
  }) async {
    context = ctx;
    _persistentSession = persistentSession;

    final realm = dotenv.env['REALM'] ?? '';
    final issuer = await Issuer.discover(Uri.parse(realm));
    final client = Client(
      issuer,
      dotenv.env['CLIENT_ID']!,
      clientSecret: dotenv.env['CLIENT_SECRET'],
    );

    _flow = Flow.authorizationCode(
      client,
      redirectUri: Uri.parse('pt.up.fe.ni.uni://auth'),
      scopes: [
        'openid',
        'profile',
        'email',
        'offline_access',
        'audience',
        'uporto_data',
      ],
    );

    await _invoke(_flow!.authenticationUri);
  }

  Future<void> finishFederatedAuthentication(Uri uri) async {
    final Credential credential = await _flow!.callback(uri.queryParameters);
    final userInfo = (await credential.getUserInfo()).toJson();
    final token = (await credential.getTokenResponse()).accessToken;

    if (token == null) {
      Logger().e('Failed to get token from SIGARRA');
      throw Exception('Failed to get token from SIGARRA');
    }

    final studentNumber = userInfo['nmec'] as String;
    final faculties = List<String>.from(userInfo['ous'] as List)
        .map((element) => element.toLowerCase())
        .toList();

    final session = await NetworkRouter.loginWithToken(
      token,
      studentNumber,
      faculties,
      persistentSession: _persistentSession,
    );

    if (session == null) {
      throw Exception('Failed to login with token');
    }

    setState(session);

    if (_persistentSession && credential.refreshToken != null) {
      await PreferencesController.saveSessionRefreshToken(
        credential.refreshToken!,
        studentNumber,
        faculties,
      );
      _persistentSession = false;
    }

    Future.delayed(
      const Duration(seconds: 20),
      () => {NotificationManager().initializeNotifications()},
    );

    await acceptTermsAndConditions();
  }
}
