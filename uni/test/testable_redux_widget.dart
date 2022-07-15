import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';

Widget testableReduxWidget(
    {required Widget child, required Store<AppState> store}) {
  return StoreProvider(
    store: store,
    child: MaterialApp(
      home: child,
    ),
  );
}
