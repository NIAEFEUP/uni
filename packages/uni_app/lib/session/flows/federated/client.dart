import 'package:http/http.dart' as http;
import 'package:uni/http/client/timeout.dart';

class FederatedDefaultClient extends http.BaseClient {
  FederatedDefaultClient({Duration timeout = const Duration(seconds: 25)})
    : inner = TimeoutClient(http.Client(), timeout: timeout);

  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return inner.send(request);
  }
}
