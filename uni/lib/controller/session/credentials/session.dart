import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/session/credentials/request.dart';
import 'package:uni/controller/session/session.dart';

part '../../../generated/controller/session/credentials/session.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialsSession extends Session {
  CredentialsSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.password,
  });

  // Serialization logic

  factory CredentialsSession.fromJson(Map<String, dynamic> json) =>
      _$CredentialsSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CredentialsSessionToJson(this);

  // Session implementation

  final String password;

  @override
  CredentialsSessionRequest createRefreshRequest() => CredentialsSessionRequest(
        username: username,
        password: password,
      );
}
