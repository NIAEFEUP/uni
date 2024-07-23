import 'package:json_annotation/json_annotation.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/session/federated/request.dart';
import 'package:uni/controller/session/request.dart';
import 'package:uni/controller/session/session.dart';

part '../../../generated/controller/session/federated/session.g.dart';

@JsonSerializable()
class FederatedSession extends Session {
  FederatedSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.credential,
  });

  // Serialization logic

  factory FederatedSession.fromJson(Map<String, dynamic> json) =>
      _$FederatedSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FederatedSessionToJson(this);

  // Session implementation

  final Credential credential;

  @override
  SessionRequest<Session> createRefreshRequest() => FederatedSessionRequest(
        username: username,
        faculties: faculties,
        credential: credential,
      );
}
