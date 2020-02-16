import 'package:app_feup/model/SchedulePageModel.dart';
import 'package:app_feup/view/Pages/BusStopNextArrivalsPage.dart';
import 'package:app_feup/controller/Logout.dart';
import 'package:app_feup/view/NavigationService.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/view/Pages/AboutPageView.dart';
import 'package:app_feup/view/Pages/BugReportPageView.dart';
import 'package:app_feup/controller/Middleware.dart';
import 'package:app_feup/view/Pages/LoginPageView.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Pages/SplashPageView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'controller/OnStartUp.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'redux/Reducers.dart';
import 'package:app_feup/model/AppState.dart';
import 'utils/Constants.dart' as Constants;

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
              case '/' + Constants.NAV_PERSONAL_AREA:
                return MaterialPageRoute(
                    builder: (context) => HomePageView(), settings: settings);
              case '/' + Constants.NAV_SCHEDULE:
                return MaterialPageRoute(
                    builder: (context) => SchedulePage(), settings: settings);
              case '/' + Constants.NAV_EXAMS:
                return MaterialPageRoute(
                    builder: (context) => ExamsPageView(), settings: settings);
              case '/' + Constants.NAV_STOPS:
                return MaterialPageRoute(
                    builder: (context) => BusStopNextArrivalsPage(), settings: settings);
              case '/' + Constants.NAV_ABOUT:
                return MaterialPageRoute(
                    builder: (context) => AboutPageView(), settings: settings);
              case '/' + Constants.NAV_BUG_REPORT:
                return MaterialPageRoute(
                    builder: (context) => BugReportPageView(),
                    settings: settings,
                    maintainState: false);
              case '/' + Constants.NAV_LOG_OUT:
                return MaterialPageRoute(builder: (context) { logout(context); return LoginPageView();});
              }
            }
      ),
    );
  }
}
