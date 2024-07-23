import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/session/credentials/session.dart';
import 'package:uni/controller/session/federated/session.dart';
import 'package:uni/controller/session/request.dart';

const _authenticatedSessions = [
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

  factory Session.fromJson(Map<String, dynamic> json) {
    for (final fromJson in _authenticatedSessions) {
      try {
        return fromJson(json);
      } catch (err) {
        // ignore
      }
    }

    throw Exception('Unknown session type');
  }

  Map<String, dynamic> toJson();

  // Session implementation

  final String username;
  final List<String> faculties;
  @CookieConverter()
  final List<Cookie> cookies; // TODO(limwa): use a CookieJar

  SessionRequest<Session> createRefreshRequest();
}

class CookieConverter implements JsonConverter<Cookie, String> {
  const CookieConverter();

  @override
  Cookie fromJson(String json) => Cookie.fromSetCookieValue(json);

  @override
  String toJson(Cookie object) => object.toString();
}
