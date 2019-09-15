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
      if (!store.state.content['session'].persistentSession) {
        return NavigationService.navigateTo('Login');
      }
      return Future.value();
    };
  }
}