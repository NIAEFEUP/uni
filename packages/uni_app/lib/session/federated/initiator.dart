import 'package:openid_client/openid_client.dart';
import 'package:uni/session/federated/request.dart';
import 'package:uni/session/initiator.dart';
import 'package:uni/session/request.dart';

class FederatedSessionInitiator extends SessionInitiator {
  FederatedSessionInitiator({
    required this.realm,
    required this.clientId,
    required this.redirectUri,
    required this.delegateAuthentication,
  });

  final Uri realm;
  final String clientId;
  final Uri redirectUri;
  final Future<Uri> Function(Flow flow) delegateAuthentication;

  @override
  Future<SessionRequest> initiate() async {
    final issuer = await Issuer.discover(realm);
    final client = Client(
      issuer,
      clientId,
    );

    final flow = Flow.authorizationCodeWithPKCE(
      client,
      scopes: [
        'openid',
        'profile',
        'email',
        'offline_access',
        'audience',
        'uporto_data',
      ],
    )..redirectUri = redirectUri;

    final uri = await delegateAuthentication(flow);
    final credential = await flow.callback(uri.queryParameters);

    return FederatedSessionRequest(credential: credential);
  }
}
