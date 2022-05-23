import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

Widget testableReduxWidget({Widget child, Store<AppState> store}) {
  return StoreProvider(
    child: MaterialApp(
      home: child,
    ),
    store: store,
  );
}
