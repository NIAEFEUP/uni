import 'dart:async';

import 'package:uni/app_links/uni_app_links.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/session/logout/logout_handler.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UniLogoutHandler extends LogoutHandler {
  @override
  FutureOr<void> closeFederatedSession(FederatedSession session) async {
    final appLinks = UniAppLinks();

    // await appLinks.logout.intercept((redirectUri) async {
    final logoutUri = session.credential.generateLogoutUrl(
      redirectUri: appLinks.logout.redirectUri,
    );

    if (logoutUri == null) {
      throw Exception('Failed to generate logout url');
    }

    await launchUrl(logoutUri);
    // });

    // await closeInAppWebView();
  }

  @override
  FutureOr<void> close(Session session) {
    NavigationService.logoutAndPopHistory();
    return super.close(session);
  }
}
