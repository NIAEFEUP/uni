import 'package:http/http.dart' as http;
import 'package:uni/http/client/timeout.dart';

class FederatedDefaultClient extends http.BaseClient {
  FederatedDefaultClient()
      : inner = TimeoutClient(
          http.Client(),
          timeout: const Duration(seconds: 5),
        );

  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return inner.send(request);
  }
}
