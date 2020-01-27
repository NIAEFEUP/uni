import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/NavigationService.dart';
import 'package:redux/redux.dart';
import 'networking/NetworkRouter.dart';

class OnStartUp {
  static onStart(Store<AppState> store){
    setHandleReloginFail(store);
  }

  static setHandleReloginFail(Store<AppState> store){
    NetworkRouter.onReloginFail = () {
      print("Á+SPJIG'NUHEGP ISDH  GPAO");
      if (!store.state.content['session'].persistentSession && store.state.content['session'].authenticated) {
        return NavigationService.logout();
      }
      return Future.value();
    };
  }
}