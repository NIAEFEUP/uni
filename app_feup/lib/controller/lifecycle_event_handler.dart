import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';

class LifecycleEventHandler extends WidgetsBindingObserver{
  final Store<AppState> store;

  LifecycleEventHandler({this.store});
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      loadUserInfoToState(store);
    }
  }


}