import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


Widget makeTestableWidget({Widget child, Store<AppState> store}){
  return StoreProvider(
    child: 
      MaterialApp(
      home: child,
    ),
    store: store,
  );
}