import 'package:uni/controller/session/credentials/request.dart';
import 'package:uni/controller/session/federated/request.dart';
import 'package:uni/controller/session/session.dart';

const _requestsFromJson = [
  FederatedSessionRequest.fromJson,
  CredentialsSessionRequest.fromJson,
];

abstract class SessionRequest {
  // Serialization logic

  static SessionRequest fromJson(Map<String, dynamic> json) {
    for (final fromJson in _requestsFromJson) {
      try {
        return fromJson(json);
      } catch (err) {
        // ignore
      }
    }

    throw Exception('Unknown session request type');
  }

  Map<String, dynamic> toJson();

  // Request implementation

  Future<Session> perform();
}
