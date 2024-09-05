import 'package:http/http.dart' as http;
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/credentials/request.dart';

class CredentialsSessionInitiator extends SessionInitiator {
  CredentialsSessionInitiator({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  CredentialsSessionRequest initiate([http.Client? httpClient]) =>
      CredentialsSessionRequest(
        username: username,
        password: password,
      );
}
