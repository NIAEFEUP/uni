import 'package:json_annotation/json_annotation.dart';
import 'package:uni/session/base/session.dart';
import 'package:uni/session/credentials/request.dart';

part '../../generated/session/credentials/session.g.dart';

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

  // @override
  // Future<void> close() async {
  //   await super.close();

  //   final url = '${NetworkRouter.getBaseUrl(faculties[0])}vld_validacao.sair';
  //   final response = await http.get(url.toUri()); // TODO: make use of UniClient

  //   if (response.statusCode == 200) {
  //     Logger().i('Logout Successful');
  //   } else {
  //     Logger().i('Logout Failed');
  //   }
  // }
}
