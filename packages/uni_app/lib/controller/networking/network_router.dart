import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:uni/http/client/authenticated.dart';
import 'package:uni/http/client/timeout.dart';
import 'package:uni/session/authentication_controller.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/uri.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

/// Manages the networking of the app.
class NetworkRouter {
  /// The HTTP client used for all requests.
  /// Can be set to null to use the default client.
  /// This is useful for testing.
  static http.Client? httpClient;

  static AuthenticationController? authenticationController;

  /// The timeout for Sigarra login requests.
  static const Duration _requestTimeout = Duration(seconds: 30);

  /// Returns the base url of the user's faculties.
  static List<String> getBaseUrls(List<String> faculties) {
    return faculties.map(getBaseUrl).toList();
  }

  /// Returns the base url of the user's faculty.
  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  /// Returns the base url from the user's previous session.
  static List<String> getBaseUrlsFromSession(Session session) {
    return NetworkRouter.getBaseUrls(session.faculties);
  }

  static Future<http.Response> getWithCookies(
    String url,
    Map<String, String> query,
    Session session,
  ) async {
    final controller =
        authenticationController ?? AuthenticationController(session);

    final client = AuthenticatedClient(
      TimeoutClient(
        httpClient ?? http.Client(),
        timeout: _requestTimeout,
      ),
      controller: controller,
    );

    final parsedUrl = url.toUri();

    final allQueryParameters = {...parsedUrl.queryParametersAll};
    for (final entry in query.entries) {
      final existingValue = allQueryParameters[entry.key];
      allQueryParameters[entry.key] = [
        if (existingValue != null) ...existingValue,
        entry.value,
      ];
    }

    final requestUri = parsedUrl
        .replace(queryParameters: allQueryParameters)
        .normalizeQueryComponent();

    return client.get(requestUri);
  }
}
