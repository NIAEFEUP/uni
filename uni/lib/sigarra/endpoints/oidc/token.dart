import 'dart:convert';
import 'dart:io';

import 'package:uni/http/utils.dart';
import 'package:uni/sigarra/options.dart';

/// Returns the cookies for SIGARRA using the OIDC token.
///
/// The client must be authorized to make this request.
Future<List<Cookie>> getCookies({
  BaseRequestOptions? options,
}) async {
  options = options ?? BaseRequestOptions();

  final tokenUrl = options.baseUrl.resolve('auth/oidc/token');
  final response = await options.client.post(
    tokenUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['result'] == 'OK') {
      return extractCookies(response);
    }
  }

  throw Exception('Failed to get token from SIGARRA');
}
