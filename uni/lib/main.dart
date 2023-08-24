import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/background_workers/background_callback.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/library_reservations_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/about/about.dart';
import 'package:uni/view/bug_report/bug_report.dart';
import 'package:uni/view/bus_stop_next_arrivals/bus_stop_next_arrivals.dart';
import 'package:uni/view/calendar/calendar.dart';
import 'package:uni/view/common_widgets/page_transition.dart';
import 'package:uni/view/course_units/course_units.dart';
import 'package:uni/view/exams/exams.dart';
import 'package:uni/view/home/home.dart';
import 'package:uni/view/library/library.dart';
import 'package:uni/view/locations/locations.dart';
import 'package:uni/view/logout_route.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/restaurant/restaurant_page_view.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/splash/splash.dart';
import 'package:uni/view/theme.dart';
import 'package:uni/view/theme_notifier.dart';
import 'package:uni/view/useful_info/useful_info.dart';
import 'package:workmanager/workmanager.dart';

SentryEvent? beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<void> main() async {
  final stateProviders = StateProviders(
    LectureProvider(),
    ExamProvider(),
    BusStopProvider(),
    RestaurantProvider(),
    ProfileProvider(),
    CourseUnitsInfoProvider(),
    SessionProvider(),
    CalendarProvider(),
    LibraryOccupationProvider(),
    LibraryReservationsProvider(),
    FacultyLocationsProvider(),
    HomePageProvider(),
    ReferenceProvider(),
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    workerStartCallback,
    isInDebugMode: !kReleaseMode,
    // run workmanager in debug mode when app is in debug mode
  );

  await dotenv
      .load(fileName: 'assets/env/.env', isOptional: true)
      .onError((error, stackTrace) {
    Logger().e('Error loading .env file: $error', error, stackTrace);
  });

  final savedTheme = await AppSharedPreferences.getThemeMode();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://a2661645df1c4992b24161010c5e0ecb@o553498.ingest.sentry.io/5680848';
    },
    appRunner: () => {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => stateProviders.lectureProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.examProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.busStopProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.restaurantProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.profileProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.courseUnitsInfoProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.sessionProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.calendarProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.libraryOccupationProvider,
            ),
            ChangeNotifierProvider(
                create: (context) =>
                    stateProviders.libraryReservationsProvider,),
            ChangeNotifierProvider(
              create: (context) => stateProviders.facultyLocationsProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.homePageProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.referenceProvider,
            ),
          ],
          child: ChangeNotifierProvider<ThemeNotifier>(
            create: (_) => ThemeNotifier(savedTheme),
            child: const MyApp(),
          ),
        ),
      )
    },
  );
}

/// Manages the state of the app
///
/// This class is necessary to track the app's state for
/// the current execution
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

/// Manages the app depending on its current state
class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) => MaterialApp(
        title: 'uni',
        theme: applicationLightTheme,
        darkTheme: applicationDarkTheme,
        themeMode: themeNotifier.getTheme(),
        home: const SplashScreen(),
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          final transitions = <String, Route<dynamic>>{
            '/${DrawerItem.navPersonalArea.title}':
                PageTransition.makePageTransition(
              page: const HomePageView(),
              settings: settings,
            ),
            '/${DrawerItem.navSchedule.title}':
                PageTransition.makePageTransition(
              page: const SchedulePage(),
              settings: settings,
            ),
            '/${DrawerItem.navExams.title}': PageTransition.makePageTransition(
              page: const ExamsPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navStops.title}': PageTransition.makePageTransition(
              page: const BusStopNextArrivalsPage(),
              settings: settings,
            ),
            '/${DrawerItem.navCourseUnits.title}':
                PageTransition.makePageTransition(
              page: const CourseUnitsPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navLocations.title}':
                PageTransition.makePageTransition(
              page: const LocationsPage(),
              settings: settings,
            ),
            '/${DrawerItem.navRestaurants.title}':
                PageTransition.makePageTransition(
              page: const RestaurantPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navCalendar.title}':
                PageTransition.makePageTransition(
              page: const CalendarPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navLibraryOccupation.title}':
                PageTransition.makePageTransition(
              page: const LibraryPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navLibraryReservations.title}':
                PageTransition.makePageTransition(
                    page: const LibraryPageView(
                      startOnOccupationTab: true,
                    ),
                    settings: settings,),
            '/${DrawerItem.navUsefulInfo.title}':
                PageTransition.makePageTransition(
              page: const UsefulInfoPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navAbout.title}': PageTransition.makePageTransition(
              page: const AboutPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navBugReport.title}':
                PageTransition.makePageTransition(
              page: const BugReportPageView(),
              settings: settings,
              maintainState: false,
            ),
            '/${DrawerItem.navLogOut.title}': LogoutRoute.buildLogoutRoute()
          };
          return transitions[settings.name];
        },
      ),
    );
  }
}
