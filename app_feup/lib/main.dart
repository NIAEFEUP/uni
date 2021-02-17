import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/view/Pages/about_page_view.dart';
import 'package:uni/view/Pages/bug_report_page_view.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/login_page_view.dart';
import 'package:uni/view/Pages/splash_page_view.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/theme.dart';
import 'package:uni/utils/constants.dart' as Constants;

import 'controller/logout.dart';
import 'controller/on_start_up.dart';
import 'model/schedule_page_model.dart';

final Store<AppState> state = Store<AppState>(appReducers,
    /* Function defined in the reducers file */
    initialState: AppState(null),
    middleware: [generalMiddleware]);

void main() {
  OnStartUp.onStart(state);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(
        state: Store<AppState>(appReducers,
            /* Function defined in the reducers file */
            initialState: AppState(null),
            middleware: [generalMiddleware]));
  }
}

class MyAppState extends State<MyApp> {
  MyAppState({@required this.state}) {}

  final Store<AppState> state;

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
            switch (settings.name) {
              case '/' + Constants.navPersonalArea:
                return MaterialPageRoute(
                    builder: (context) => HomePageView(), settings: settings);
              case '/' + Constants.navSchedule:
                return MaterialPageRoute(
                    builder: (context) => SchedulePage(), settings: settings);
              case '/' + Constants.navExams:
                return MaterialPageRoute(
                    builder: (context) => ExamsPageView(), settings: settings);
              case '/' + Constants.navStops:
                return MaterialPageRoute(
                    builder: (context) => BusStopNextArrivalsPage(),
                    settings: settings);
              case '/' + Constants.navAbout:
                return MaterialPageRoute(
                    builder: (context) => AboutPageView(), settings: settings);
              case '/' + Constants.navBugReport:
                return MaterialPageRoute(
                    builder: (context) => BugReportPageView(),
                    settings: settings,
                    maintainState: false);
              case '/' + Constants.navLogOut:
                return MaterialPageRoute(builder: (context) {
                  logout(context);
                  return LoginPageView();
                });
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 60),
        (Timer t) => state.dispatch(SetCurrentTimeAction(DateTime.now())));
  }
}
