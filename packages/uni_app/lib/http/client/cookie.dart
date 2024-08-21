import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class CookieClient extends http.BaseClient {
  CookieClient(
    this._inner, {
    required this.cookies,
  });

  final http.Client _inner;
  final List<Cookie> cookies;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final initialCookies = request.headers[HttpHeaders.cookieHeader];
    final allCookies = [
      if (initialCookies != null) initialCookies,
      ...cookies.map((cookie) => cookie.toString()),
    ].join('; ');

    request.headers[HttpHeaders.cookieHeader] = allCookies;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
