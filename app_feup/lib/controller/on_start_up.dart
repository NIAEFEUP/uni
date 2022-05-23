import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/navigation_service.dart';

import 'networking/network_router.dart';

class OnStartUp {
  static onStart(Store<AppState> store) {
    setHandleReloginFail(store);
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
