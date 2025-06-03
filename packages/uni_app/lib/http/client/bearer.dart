import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class BearerClient extends http.BaseClient {
  BearerClient(this._inner, {required FutureOr<String> Function() token})
    : _token = token;

  final http.Client _inner;
  final FutureOr<String> Function() _token;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _token();
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
