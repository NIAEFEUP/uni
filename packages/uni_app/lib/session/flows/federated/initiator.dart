import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:uni/session/flows/base/initiator.dart';
import 'package:uni/session/flows/federated/request.dart';

class FederatedSessionInitiator extends SessionInitiator {
  FederatedSessionInitiator({
    required this.realm,
    required this.clientId,
    required this.performAuthentication,
  });

  final Uri realm;
  final String clientId;
  final Future<Uri> Function(Flow flow) performAuthentication;

  @override
  Future<FederatedSessionRequest> initiate([http.Client? httpClient]) async {
    final issuer = await Issuer.discover(realm);
    final client = Client(issuer, clientId, httpClient: httpClient);

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
    );

    final uri = await performAuthentication(flow);
    final credential = await flow.callback(uri.queryParameters);

    return FederatedSessionRequest(credential: credential);
  }
}
