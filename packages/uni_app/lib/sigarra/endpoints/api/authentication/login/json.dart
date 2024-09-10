import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/sigarra/endpoints/api/authentication/login/json.g.dart';

@JsonSerializable(createToJson: false)
class LoginJsonResponse {
  const LoginJsonResponse({
    required this.authenticated,
    required this.username,
  });

  factory LoginJsonResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginJsonResponseFromJson(json);

  final bool authenticated;

  @JsonKey(name: 'codigo')
  final String username;
}
