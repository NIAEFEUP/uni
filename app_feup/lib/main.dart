import 'package:flutter/material.dart';
import 'view/Pages/SplashPageView.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/reducers.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final Store<AppState> state = Store<AppState>(
    appReducers, /* Function defined in the reducers file */
    initialState: new AppState(null),
    middleware: [thunkMiddleware]
  );

  @override
  Widget build(BuildContext context) => StoreProvider(
    store: this.state,
    child: MaterialApp(
      home: new MaterialApp(
        title: 'Flutter Demo',
        theme: applicationTheme,
        home: SplashScreen(),
      )
    ),
  );

}