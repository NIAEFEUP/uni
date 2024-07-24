import 'package:uni/controller/session/credentials/request.dart';
import 'package:uni/controller/session/session.dart';

class CredentialsSession extends Session {
  CredentialsSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.password,
  });

  final String password;

  @override
  CredentialsSessionRequest createRefreshRequest() => CredentialsSessionRequest(
        username: username,
        password: password,
      );
}
