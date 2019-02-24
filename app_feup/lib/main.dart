import 'package:app_feup/view/Pages/ClassificationsPageView.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/view/Pages/MapPageView.dart';
import 'package:app_feup/view/Pages/MenuPageView.dart';
import 'package:app_feup/view/Pages/ParkPageView.dart';
import 'package:app_feup/view/Pages/SchedulePageView.dart';
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
        title: 'App FEUP',
        theme: applicationTheme,
        home: SplashScreen(),
      routes: {
          '/Área Pessoal': (context) => HomePageView(),
          '/Horário': (context) => SchedulePageView(),
          '/Classificações': (context) => ClassificationsPageView(),
          '/Ementa': (context) => MenuPageView(),
          '/Mapa de Exames': (context) => ExamsPageView(),
          '/Parques': (context) => ParkPageView(),
          '/Mapa FEUP': (context) => MapPageView(),
      },
    )
  );
}
