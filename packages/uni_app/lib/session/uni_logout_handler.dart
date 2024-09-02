import 'dart:async';

import 'package:uni/session/base/session.dart';
import 'package:uni/session/federated/session.dart';
import 'package:uni/session/logout_handler.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UniLogoutHandler extends LogoutHandler {
  @override
  FutureOr<void> closeFederatedSession(FederatedSession session) async {
    final homeUri = Uri.parse('pt.up.fe.ni.uni://home');
    final logoutUri =
        session.credential.generateLogoutUrl(redirectUri: homeUri);

    if (logoutUri == null) {
      throw Exception('Failed to generate logout url');
    }

    await launchUrl(logoutUri);
  }

  @override
  FutureOr<void> close(Session session) {
    NavigationService.logoutAndPopHistory();
    return super.close(session);
  }
}
