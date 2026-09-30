import 'dart:async';

import 'package:uni/app_links/uni_app_links.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/session/flows/federated/session.dart';
import 'package:uni/session/logout/logout_handler.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UniLogoutHandler extends LogoutHandler {
  @override
  Future<void>? closeFederatedSession(FederatedSession session) async {
    final appLinks = UniAppLinks();

    // 1. Attempt token revocation via RFC 7009
    try {
      await session.credential.revoke();
    } catch (_) {
      // Best-effort revocation; continue to end-session URL
    }

    // 2. Launch end-session URL safely
    try {
      final logoutUri = session.credential.generateLogoutUrl(
        redirectUri: appLinks.logout.redirectUri,
      );

      if (logoutUri != null && await canLaunchUrl(logoutUri)) {
        await launchUrl(logoutUri);
      }
    } catch (_) {
      // Avoid crashing if browser cannot be launched
    }
  }

  @override
  Future<void>? close(Session session) async {
    await NavigationService.logoutAndPopHistory();
    return super.close(session);
  }
}
