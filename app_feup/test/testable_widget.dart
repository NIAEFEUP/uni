import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';

Widget makeTestableWidget({Widget child}) {
  return StoreProvider(
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
      store: Store<AppState>(
        (state, context) => null,
        initialState: AppState({}),
      ));
}
