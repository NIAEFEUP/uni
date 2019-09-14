import 'package:app_feup/model/SchedulePageModel.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/view/Pages/ClassificationsPageView.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/view/Pages/MapPageView.dart';
import 'package:app_feup/view/Pages/MenuPageView.dart';
import 'package:app_feup/view/Pages/ParkPageView.dart';
import 'package:app_feup/view/Pages/AboutPageView.dart';
import 'package:app_feup/view/Pages/BugReportPageView.dart';
import 'package:app_feup/controller/Middleware.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Pages/SplashPageView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'redux/Reducers.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/controller/LifecycleEventHandler.dart';

List<Exam> exams;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> {

  final Store<AppState> state = Store<AppState>(
    appReducers, /* Function defined in the reducers file */
    initialState: new AppState(null),
    middleware: [generalMiddleware]
  );

  WidgetsBindingObserver lifeCycleEventHandler;

  @override
  Widget build(BuildContext context) {
   SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
   return StoreProvider(
    store: this.state,
    child: MaterialApp(
        title: 'App FEUP',
        theme: applicationTheme,
        home: SplashScreen(),
        routes: {
            '/Área Pessoal': (context) {
              return HomePageView();
            },
            '/Horário': (context) {
              return SchedulePage();
            },
            '/Classificações': (context) {
              return ClassificationsPageView();
            },
            '/Ementa': (context) {
              return MenuPageView();
            },
            '/Mapa de Exames': (context) {
              return ExamsPageView();
            },
            '/Parques': (context) {
              return ParkPageView();
            },
            '/Mapa FEUP': (context) {
              return MapPageView();
            },
            '/About': (context) {
              return AboutPageView();
            },
            '/Bug Report': (context) {
              return BugReportPageView();
            }
        },
    )
  );}

  @override
  void initState() {
    super.initState();
    this.lifeCycleEventHandler = new LifecycleEventHandler(store: this.state);
    WidgetsBinding.instance.addObserver(this.lifeCycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this.lifeCycleEventHandler);
    super.dispose();
  }
}


