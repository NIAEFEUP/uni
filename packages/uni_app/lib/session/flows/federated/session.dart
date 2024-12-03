import 'package:json_annotation/json_annotation.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/flows/federated/request.dart';

part '../../../generated/session/flows/federated/session.g.dart';

@JsonSerializable(explicitToJson: true)
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

  final Credential credential;

  @override
  FederatedSessionRequest createRefreshRequest() => FederatedSessionRequest(
        credential: credential,
      );
}
