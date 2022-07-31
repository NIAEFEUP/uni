import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/on_start_up.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/schedule_page_model.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Pages/about_page_view.dart';
import 'package:uni/view/Pages/bug_report_page_view.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';
import 'package:uni/view/Pages/splash_page_view.dart';
import 'package:uni/view/Pages/useful_contacts_card_page_view.dart';
import 'package:uni/view/Pages/useful_links_card_page_view.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/theme.dart';
import 'package:uni/view/theme_notifier.dart';

SentryEvent? beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<void> main() async {
  /// Stores the state of the app
  final Store<AppState> state = Store<AppState>(appReducers,
      /* Function defined in the reducers file */
      initialState: AppState(null),
      middleware: [generalMiddleware]);

  OnStartUp.onStart(state);
  WidgetsFlutterBinding.ensureInitialized();
  final savedTheme = await AppSharedPreferences.getThemeMode();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://a2661645df1c4992b24161010c5e0ecb@o553498.ingest.sentry.io/5680848';
  },
      appRunner: () => {
            runApp(ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier(savedTheme),
              child: const MyApp(),
            ))
          });
}

/// Manages the state of the app
///
/// This class is necessary to track the app's state for
/// the current execution
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

/// Manages the app depending on its current state
class MyAppState extends State<MyApp> {
  final Store<AppState> state;

  MyAppState()
      : state = Store<AppState>(appReducers,
            initialState: AppState(null), middleware: [generalMiddleware]);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
        store: state,
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, _) => MaterialApp(
              title: 'uni',
              theme: applicationLightTheme,
              darkTheme: applicationDarkTheme,
              themeMode: themeNotifier.getTheme(),
              home: const SplashScreen(),
              navigatorKey: NavigationService.navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/${constants.navPersonalArea}':
                    return PageTransition.makePageTransition(
                        page: const HomePageView(), settings: settings);
                  case '/${constants.navSchedule}':
                    return PageTransition.makePageTransition(
                        page: const SchedulePage(), settings: settings);
                  case '/${constants.navExams}':
                    return PageTransition.makePageTransition(
                        page: const ExamsPageView(), settings: settings);
                  case '/${constants.navStops}':
                    return PageTransition.makePageTransition(
                        page: const BusStopNextArrivalsPage(),
                        settings: settings);
                  case '/${constants.navUsefulContacts}':
                    return PageTransition.makePageTransition(
                        page: const UsefulContactsCardView(),
                        settings: settings);
                  case '/${constants.navUsefulLinks}':
                    return PageTransition.makePageTransition(
                        page: const UsefulLinksCardView(), settings: settings);
                  case '/${constants.navAbout}':
                    return PageTransition.makePageTransition(
                        page: const AboutPageView(), settings: settings);
                  case '/${constants.navBugReport}':
                    return PageTransition.makePageTransition(
                        page: const BugReportPageView(),
                        settings: settings,
                        maintainState: false);
                  case '/${constants.navLogOut}':
                    return LogoutRoute.buildLogoutRoute();
                }
                return null;
              }),
        ));
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 60),
        (Timer t) => state.dispatch(SetCurrentTimeAction(DateTime.now())));
  }
}
