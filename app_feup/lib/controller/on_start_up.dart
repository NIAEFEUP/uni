import 'package:redux/redux.dart';
import 'package:uni/controller/notifications/local_notifications.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/navigation_service.dart';

import 'networking/network_router.dart';

class OnStartUp {
  onStart(Store<AppState> store) {
    setHandleReloginFail(store);
    LocalNotifications().start();
  }

  static setHandleReloginFail(Store<AppState> store) {
    NetworkRouter.onReloginFail = () {
      if (!store.state.content['session'].persistentSession) {
        return NavigationService.logout();
      }
      return Future.value();
    };
  }
}
