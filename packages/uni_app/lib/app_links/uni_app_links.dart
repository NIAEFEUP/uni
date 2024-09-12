import 'dart:async';

import 'package:app_links/app_links.dart';

final _authUri = Uri(scheme: 'pt.up.fe.ni.uni', host: 'auth');

extension _StripQueryParameters on Uri {
  Uri stripQueryParameters() {
    return Uri(scheme: scheme, host: host, path: path);
  }
}

class UniAppLinks {
  final login = _AuthenticationAppLink(
    redirectUri: _authUri.replace(path: '/login'),
  );

  final logout = _AuthenticationAppLink(
    redirectUri: _authUri.replace(path: '/logout'),
  );
}

class _AuthenticationAppLink {
  _AuthenticationAppLink({required this.redirectUri});

  final AppLinks _appLinks = AppLinks();
  final Uri redirectUri;

  Future<Uri> intercept(
      FutureOr<void> Function(Uri redirectUri) callback) async {
    final interceptedUri = _appLinks.uriLinkStream
        .firstWhere((uri) => redirectUri == uri.stripQueryParameters());

    await callback(redirectUri);
    final data = await interceptedUri;
    return data;
  }
}
