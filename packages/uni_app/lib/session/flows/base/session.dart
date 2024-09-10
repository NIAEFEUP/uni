import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/credentials/session.dart';
import 'package:uni/session/flows/federated/session.dart';

const _sessionsFromJson = [
  FederatedSession.fromJson,
  CredentialsSession.fromJson,
];

abstract class Session {
  Session({
    required this.username,
    required this.cookies,
    required this.faculties,
  }) : assert(faculties.isNotEmpty, 'session must have faculties');

  // Serialization logic

  static Session? fromJson(Map<String, dynamic> json) {
    for (final fromJson in _sessionsFromJson) {
      try {
        return fromJson(json);
      } catch (err) {
        // ignore
      }
    }

    return null;
  }

  Map<String, dynamic> toJson();

  // Session implementation

  final String username;
  final List<String> faculties;
  @CookieConverter()
  final List<Cookie> cookies; // TODO(limwa): use a CookieJar

  String get mainFaculty => faculties.first;

  SessionRequest createRefreshRequest();

  /// Executed when the authorization provided by this session is rejected.
  ///
  /// This is useful for performing cleanup operations, such as invalidating
  /// session cookies, since they will no longer be used.
  // @mustCallSuper
  // FutureOr<void> onRejection([http.Client? httpClient]) async {
  //   final client = httpClient ?? http.Client();

  //   try {
  //     await authentication.logout(
  //       options: FacultyRequestOptions(
  //         client: CookieClient(client, cookies: () => cookies),
  //       ),
  //     );
  //   } catch (err, st) {
  //     unawaited(Sentry.captureException(err, stackTrace: st));
  //   }
  // }
}

class CookieConverter implements JsonConverter<Cookie, String> {
  const CookieConverter();

  @override
  Cookie fromJson(String json) => Cookie.fromSetCookieValue(json);

  @override
  String toJson(Cookie object) => object.toString();
}
