import 'package:flutter/material.dart';
import 'package:app_feup/view/Pages/SplashPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'redux/reducers.dart';
import 'controller/parsers/parser-exams.dart';

List<Exam> exams;

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
        title: 'Flutter Demo',
        theme: applicationTheme,
        home: SplashScreen(),
    )
  );
}
