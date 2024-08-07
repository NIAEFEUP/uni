import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/session/credentials/session.dart';
import 'package:uni/controller/session/federated/session.dart';
import 'package:uni/controller/session/request.dart';

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

  SessionRequest createRefreshRequest();

  @mustCallSuper
  Future<void> close() async {}
}

class CookieConverter implements JsonConverter<Cookie, String> {
  const CookieConverter();

  @override
  Cookie fromJson(String json) => Cookie.fromSetCookieValue(json);

  @override
  String toJson(Cookie object) => object.toString();
}
