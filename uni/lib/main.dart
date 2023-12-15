import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/background_workers/background_callback.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/bus_stop_next_arrivals.dart';
import 'package:uni/view/calendar/calendar.dart';
import 'package:uni/view/common_widgets/page_transition.dart';
import 'package:uni/view/course_units/course_units.dart';
import 'package:uni/view/exams/exams.dart';
import 'package:uni/view/home/home.dart';
import 'package:uni/view/library/library.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/locations/locations.dart';
import 'package:uni/view/login/login.dart';
import 'package:uni/view/restaurant/restaurant_page_view.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/theme.dart';
import 'package:uni/view/theme_notifier.dart';
import 'package:uni/view/useful_info/useful_info.dart';
import 'package:workmanager/workmanager.dart';

SentryEvent? beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<Widget> firstRoute() async {
  final userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();

  if (userPersistentInfo != null) {
    return const HomePageView();
  }

  await acceptTermsAndConditions();
  return const LoginPageView();
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
    FacultyLocationsProvider(),
    HomePageProvider(),
    ReferenceProvider(),
  );

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager for background tasks
  await Workmanager().initialize(
    workerStartCallback,
    isInDebugMode: !kReleaseMode,
  );

  // Read environment, which may include app tokens
  await dotenv
      .load(fileName: 'assets/env/.env', isOptional: true)
      .onError((error, stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);
    Logger().e(
      'Error loading .env file: $error',
      error: error,
      stackTrace: stackTrace,
    );
  });

  final savedTheme = await AppSharedPreferences.getThemeMode();
  final savedLocale = await AppSharedPreferences.getLocale();
  final route = await firstRoute();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://a2661645df1c4992b24161010c5e0ecb@o553498.ingest.sentry.io/5680848';
    },
    appRunner: () {
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
              create: (context) => stateProviders.facultyLocationsProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.homePageProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => stateProviders.referenceProvider,
            ),
            ChangeNotifierProvider<LocaleNotifier>(
              create: (_) => LocaleNotifier(savedLocale),
            ),
            ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier(savedTheme),
            ),
          ],
          child: Application(route),
        ),
      );
    },
  );
}

/// Manages the state of the app.
/// This class is necessary to track the app's state for
/// the current execution.
class Application extends StatefulWidget {
  const Application(this.initialWidget, {super.key});

  final Widget initialWidget;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<Application> createState() => ApplicationState();
}

/// Manages the app depending on its current state
class ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, _) => MaterialApp(
        title: 'uni',
        navigatorKey: Application.navigatorKey,
        theme: applicationLightTheme,
        darkTheme: applicationDarkTheme,
        themeMode: themeNotifier.getTheme(),
        locale: localeNotifier.getLocale().localeCode,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: widget.initialWidget,
        onGenerateRoute: (RouteSettings settings) {
          final transitions = {
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
            '/${DrawerItem.navLibrary.title}':
                PageTransition.makePageTransition(
              page: const LibraryPageView(),
              settings: settings,
            ),
            '/${DrawerItem.navUsefulInfo.title}':
                PageTransition.makePageTransition(
              page: const UsefulInfoPageView(),
              settings: settings,
            ),
          };
          return transitions[settings.name];
        },
      ),
    );
  }
}
