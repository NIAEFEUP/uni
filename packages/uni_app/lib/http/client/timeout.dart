import 'package:http/http.dart' as http;

class TimeoutClient extends http.BaseClient {
  TimeoutClient(http.Client inner, {required Duration timeout})
      : _inner = inner,
        _timeout = timeout;

  final http.Client _inner;
  final Duration _timeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request).timeout(_timeout);

  @override
  void close() => _inner.close();
}
