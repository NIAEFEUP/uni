import 'package:uni/session/base/initiator.dart';
import 'package:uni/session/credentials/request.dart';

class CredentialsSessionInitiator extends SessionInitiator {
  CredentialsSessionInitiator({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  CredentialsSessionRequest initiate() => CredentialsSessionRequest(
        username: username,
        password: password,
      );
}
