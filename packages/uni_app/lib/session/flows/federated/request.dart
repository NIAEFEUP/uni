import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/fetchers/academics/faculties_fetcher.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/federated/client.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/sigarra/endpoints/oidc/oidc.dart';
import 'package:uni/sigarra/endpoints/oidc/token/response.dart';
import 'package:uni/sigarra/options.dart';
import 'package:uni/utils/constants.dart' as constants;

const tempFaculty = 'feup';

class FederatedSessionUserInfo {
  FederatedSessionUserInfo(UserInfo userInfo)
    : username = _extractUsername(userInfo),
      faculties = _extractFaculties(userInfo);

  final String username;
  final List<String> faculties;

  static String _extractUsername(UserInfo userInfo) {
    final nmec = userInfo.getTyped<String>('nmec');
    if (nmec != null && nmec.isNotEmpty) {
      return _cleanUsername(nmec);
    }
    final preferred = userInfo.preferredUsername;
    if (preferred != null && preferred.isNotEmpty) {
      return _cleanUsername(preferred);
    }
    final email = userInfo.email;
    if (email != null && email.isNotEmpty) {
      return _cleanUsername(email.split('@').first);
    }
    return _cleanUsername(userInfo.subject);
  }

  static String _cleanUsername(String username) {
    final match = RegExp(r'^up(?=\d+)', caseSensitive: false);
    return username.replaceFirst(match, '');
  }

  static List<String> _extractFaculties(UserInfo userInfo) {
    final rawOus = userInfo.getTyped<List<dynamic>>('ous');

    final ousFaculties = _tryExtractFacultiesFromOus(rawOus);

    if (ousFaculties.isNotEmpty) {
      return ousFaculties;
    }

    final email = userInfo.getTyped<String>('email');

    if (email != null) {
      final emailFaculties = _extractFacultiesFromEmail(email);
      if (emailFaculties.isNotEmpty) {
        return emailFaculties;
      }
    }

    return [];
  }

  static List<String> _tryExtractFacultiesFromOus(List<dynamic>? rawOus) {
    if (rawOus == null || rawOus.isEmpty) {
      return [];
    }

    if (rawOus.every((item) => item is String)) {
      return rawOus
          .cast<String>()
          .map((element) => element.toLowerCase())
          .where((element) => constants.faculties.contains(element))
          .toList();
    }

    return [];
  }

  static List<String> _extractFacultiesFromEmail(String email) {
    final domain = email.split('@').last.toLowerCase();

    final eduPattern = RegExp(r'^(?:edu\.)?([a-z]+)\.up\.pt$');
    final eduMatch = eduPattern.firstMatch(domain);
    if (eduMatch != null) {
      final code = eduMatch.group(1)!;
      if (constants.faculties.contains(code)) {
        return [code];
      }
      const aliases = {
        'arq': 'faup',
        'direito': 'fdup',
        'fade': 'fadeup',
        'fba': 'fbaup',
        'fc': 'fcup',
        'fcna': 'fcnaup',
        'fe': 'feup',
        'ff': 'ffup',
        'fl': 'flup',
        'fm': 'fmup',
        'fmd': 'fmdup',
        'fpce': 'fpceup',
        'letras': 'flup',
        'med': 'fmup',
      };
      final mapped = aliases[code];
      if (mapped != null && constants.faculties.contains(mapped)) {
        return [mapped];
      }
    }

    return [];
  }
}

class FederatedSessionRequest extends SessionRequest {
  FederatedSessionRequest({required this.credential});

  final Credential credential;

  TokenFailedResponse _reportExceptionAndFail<E extends Object>(
    E error,
    StackTrace st,
  ) {
    unawaited(Sentry.captureException(error, stackTrace: st));
    return const TokenFailedResponse();
  }

  @override
  Future<FederatedSession> perform([http.Client? httpClient]) async {
    httpClient ??= FederatedDefaultClient();

    final authorizedClient = credential.createHttpClient(httpClient);

    final oidc = SigarraOidc();
    final response = await oidc
        .token(options: SigarraRequestOptions(client: authorizedClient))
        .call()
        .onError<OpenIdException>(_reportExceptionAndFail)
        .onError<HttpRequestException>(_reportExceptionAndFail);

    if (!response.success) {
      throw const AuthenticationException('Failed to get OIDC token');
    }

    final userInfo = FederatedSessionUserInfo(await credential.getUserInfo());
    final successfulResponse = response.asSuccessful();

    final tempSession = FederatedSession(
      username: userInfo.username,
      faculties: userInfo.faculties.isNotEmpty
          ? userInfo.faculties
          : [tempFaculty],
      cookies: successfulResponse.cookies,
      credential: credential,
    );

    List<String> faculties = userInfo.faculties;
    try {
      final remoteFaculties = await getStudentFaculties(
        tempSession,
        httpClient,
      );
      if (remoteFaculties.isNotEmpty) {
        faculties = remoteFaculties;
      }
    } catch (err, st) {
      unawaited(Sentry.captureException(err, stackTrace: st));
      if (faculties.isEmpty) {
        rethrow;
      }
    }

    if (faculties.isEmpty) {
      faculties = [tempFaculty];
    }

    return FederatedSession(
      username: userInfo.username,
      faculties: faculties,
      cookies: successfulResponse.cookies,
      credential: credential,
    );
  }
}
