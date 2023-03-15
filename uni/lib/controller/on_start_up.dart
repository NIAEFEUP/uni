import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/navigation_service.dart';

class OnStartUp {
  static onStart(SessionProvider sessionProvider) {
    setHandleReloginFail(sessionProvider);
  }

  static setHandleReloginFail(SessionProvider sessionProvider) {
    NetworkRouter.onReloginFail = () {
      if (!sessionProvider.session.persistentSession) {
        return NavigationService.logout();
      }
      return Future.value();
    };
  }
}
