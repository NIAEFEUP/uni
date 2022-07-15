import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';

Widget makeTestableWidget({required Widget child}) {
  return StoreProvider(
      store: Store<AppState>(
        (state, context) => AppState({}),
        initialState: AppState({}),
      ),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ));
}
