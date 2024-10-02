import 'dart:io';

import 'package:http/http.dart' as http;

/// Extracts the cookies present in [response].
List<Cookie> extractCookies(http.Response response) {
  final setCookieHeaders =
      response.headersSplitValues[HttpHeaders.setCookieHeader];
  if (setCookieHeaders == null) {
    return [];
  }

  return setCookieHeaders.map(Cookie.fromSetCookieValue).toList();
}
