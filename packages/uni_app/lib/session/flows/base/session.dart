import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:uni/session/flows/base/request.dart';
import 'package:uni/session/flows/credentials/session.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/sigarra/instances.dart';

const _sessionsFromJson = [
  FederatedSession.fromJson,
  CredentialsSession.fromJson,
];

abstract class Session {
  Session({
    required this.username,
    required this.cookies,
    required this.instances,
  }) : assert(instances.isNotEmpty, 'session must have instances');

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

  @CookieConverter()
  final List<Cookie> cookies; // TODO(limwa): use a CookieJar

  @InstanceConverter()
  final List<Instance> instances;

  Instance get mainInstance => instances.first;

  SessionRequest createRefreshRequest();
}

class CookieConverter implements JsonConverter<Cookie, String> {
  const CookieConverter();

  @override
  Cookie fromJson(String json) => Cookie.fromSetCookieValue(json);

  @override
  String toJson(Cookie object) => object.toString();
}
