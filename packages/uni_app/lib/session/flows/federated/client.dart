import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/http/client/timeout.dart';

class FederatedDefaultClient extends http.BaseClient {
  FederatedDefaultClient()
    : inner = TimeoutClient(
        SentryHttpClient(),
        timeout: const Duration(seconds: 5),
      );

  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return inner.send(request);
  }
}
