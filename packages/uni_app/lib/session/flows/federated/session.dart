import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/flows/federated/request.dart';

part 'package:uni/generated/session/flows/federated/session.g.dart';

@JsonSerializable(explicitToJson: true)
class FederatedSession extends Session {
  FederatedSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.tokenResponse,
  });

  // Serialization logic

  factory FederatedSession.fromJson(Map<String, dynamic> json) =>
      _$FederatedSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FederatedSessionToJson(this);

  final AuthorizationTokenResponse tokenResponse;

  @override
  FederatedSessionRequest createRefreshRequest() =>
      FederatedSessionRequest(tokenResponse: tokenResponse);
}
