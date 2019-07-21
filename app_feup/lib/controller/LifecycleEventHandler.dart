import 'package:flutter/material.dart';
import 'package:app_feup/controller/LoadInfo.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/model/AppState.dart';

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