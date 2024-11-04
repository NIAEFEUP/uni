import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:uni/utils/uri.dart';

final _authUri = Uri(scheme: 'pt.up.fe.ni.uni', host: 'auth');

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
    FutureOr<void> Function(Uri redirectUri) callback,
  ) async {
    final interceptedUri = _appLinks.uriLinkStream
        .firstWhere((uri) => redirectUri == uri.stripQueryComponent());

    await callback(redirectUri);
    final data = await interceptedUri;
    return data;
  }
}
