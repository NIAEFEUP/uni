import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/session/federated/request.dart';
import 'package:uni/controller/session/session.dart';

class FederatedSession extends Session {
  FederatedSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.credential,
  });

  final Credential credential;

  @override
  FederatedSessionRequest createRefreshRequest() => FederatedSessionRequest(
        credential: credential,
      );
}
