import 'package:app_feup/controller/Logout.dart';
import 'package:app_feup/model/SchedulePageModel.dart';
import 'package:app_feup/view/NavigationService.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/model/LoginPageModel.dart';
import 'package:app_feup/view/Pages/AboutPageView.dart';
import 'package:app_feup/view/Pages/BugReportPageView.dart';
import 'package:app_feup/controller/Middleware.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Pages/SplashPageView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'controller/OnStartUp.dart';
import 'model/LoginPageModel.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'redux/Reducers.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/controller/LifecycleEventHandler.dart';

// Constants to guarantee less inconsistency and less error-phrone among different route usage
// Maybe placed in a separate file?
const NAV_PERSONAL_AREA = "Área Pessoal";
const NAV_SCHEDULE = "Horário";
const NAV_EXAMS = "Mapa de Exames";
const NAV_ABOUT = "Sobre";
const NAV_BUG_REPORT = "Bug Report";
const NAV_LOG_OUT = "Terminar sessão";

final Store<AppState> state = Store<AppState>(
    appReducers, /* Function defined in the reducers file */
    initialState: new AppState(null),
    middleware: [generalMiddleware]
);

void main() {
  OnStartUp.onStart(state);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  
  WidgetsBindingObserver lifeCycleEventHandler;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
      store: state,
      child: MaterialApp(
          title: 'uni',
          theme: applicationTheme,
          home: SplashScreen(),
          navigatorKey: NavigationService.navigatorKey,
          // ignore: missing_return
          onGenerateRoute: (RouteSettings settings) {
            switch(settings.name) {
              case '/' + NAV_PERSONAL_AREA:
                return MaterialPageRoute(builder: (context) => HomePageView(), settings: settings);
              case '/' + NAV_SCHEDULE:
                return MaterialPageRoute(builder: (context) => SchedulePage(), settings: settings);
              case '/' + NAV_EXAMS:
                return MaterialPageRoute(builder: (context) => ExamsPageView(), settings: settings);
              case '/' + NAV_ABOUT:
                return MaterialPageRoute(builder: (context) => AboutPageView(), settings: settings);
              case '/' + NAV_BUG_REPORT:
                return MaterialPageRoute(builder: (context) => BugReportPageView(), settings: settings, maintainState: false);
              case '/' + NAV_LOG_OUT:
                return MaterialPageRoute(builder: (context) { logout(context); return LoginPage();});
              }
            }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.lifeCycleEventHandler = new LifecycleEventHandler(store: state);
    WidgetsBinding.instance.addObserver(this.lifeCycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this.lifeCycleEventHandler);
    super.dispose();
  }
}
