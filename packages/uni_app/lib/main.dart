import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:plausible_analytics/navigator_observer.dart';
import 'package:plausible_analytics/plausible_analytics.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:uni/controller/background_workers/background_callback.dart';
import 'package:uni/controller/cleanup.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/migrations/migration_controller.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/providers/plausible/plausible_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/about/about.dart';
import 'package:uni/view/academic_path/academic_path.dart';
import 'package:uni/view/bug_report/bug_report.dart';
import 'package:uni/view/bus_stop_next_arrivals/bus_stop_next_arrivals.dart';
import 'package:uni/view/calendar/calendar.dart';
import 'package:uni/view/common_widgets/page_transition.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/exams/exams.dart';
import 'package:uni/view/faculty/faculty.dart';
import 'package:uni/view/home/edit_home.dart';
import 'package:uni/view/home/home.dart';
import 'package:uni/view/library/library.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/login/login.dart';
import 'package:uni/view/map/map.dart';
import 'package:uni/view/profile/profile.dart';
import 'package:uni/view/restaurant/restaurant_page_view.dart';
import 'package:uni/view/splash/splash.dart';
import 'package:uni/view/theme_notifier.dart';
import 'package:uni_ui/theme.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

SentryEvent? beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<String> firstRoute() async {
  final savedSession = await PreferencesController.getSavedSession();

  if (savedSession != null) {
    return '/${NavigationItem.navPersonalArea.route}';
  }

  await acceptTermsAndConditions();
  return '/${NavigationItem.navLogin.route}';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MigrationController.runMigrations();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  PreferencesController.prefs = await SharedPreferences.getInstance();

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
    ReferenceProvider(),
  );

  unawaited(cleanupCachedFiles());

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

  final plausibleUrl = dotenv.env['PLAUSIBLE_URL'];
  final plausibleDomain = dotenv.env['PLAUSIBLE_DOMAIN'];

  final ua = await userAgent();

  final plausible = plausibleUrl != null && plausibleDomain != null
      ? Plausible(plausibleUrl, plausibleDomain, userAgent: ua)
      : null;

  if (plausible == null) {
    Logger().w('Plausible is not enabled');
  }

  final savedTheme = PreferencesController.getThemeMode();
  final savedLocale = PreferencesController.getLocale();

  const route = '/splash';

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://a2661645df1c4992b24161010c5e0ecb@o553498.ingest.sentry.io/5680848';
    },
    appRunner: () {
      runApp(
        PlausibleProvider(
          plausible: plausible,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => stateProviders.sessionProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => stateProviders.profileProvider,
              ),
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
                create: (context) => stateProviders.courseUnitsInfoProvider,
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
                create: (context) => stateProviders.referenceProvider,
              ),
              ChangeNotifierProvider<LocaleNotifier>(
                create: (_) => LocaleNotifier(savedLocale),
              ),
              ChangeNotifierProvider<ThemeNotifier>(
                create: (_) => ThemeNotifier(savedTheme),
              ),
            ],
            child: const Application(route),
          ),
        ),
      );
    },
  );
}

/// Manages the state of the app.
/// This class is necessary to track the app's state for
/// the current execution.
class Application extends StatefulWidget {
  const Application(this.initialRoute, {super.key});

  final String initialRoute;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<Application> createState() => ApplicationState();
}

/// Manages the app depending on its current state
class ApplicationState extends State<Application> {
  final navigatorObservers = <NavigatorObserver>[];

  @override
  void initState() {
    super.initState();

    final plausible = context.read<Plausible?>();
    if (plausible != null) {
      navigatorObservers.add(PlausibleNavigatorObserver(plausible));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, _) => UpgradeAlert(
        navigatorKey: Application.navigatorKey,
        showIgnore: false,
        child: MaterialApp(
          title: 'uni',
          navigatorKey: Application.navigatorKey,
          theme: lightTheme,
          themeMode: ThemeMode.light, // themeNotifier.getTheme(),
          locale: localeNotifier.getLocale().localeCode,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: widget.initialRoute,
          navigatorObservers: navigatorObservers,
          onGenerateRoute: (settings) {
            final args = settings.arguments;
            final courseUnit = args is CourseUnit ? args : null;
            final transitionFunctions = <String, Route<dynamic> Function()>{
              '/${NavigationItem.navSplash.route}': () =>
                  PageTransition.splashTransitionRoute(
                    page: const SplashScreenView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navEditPersonalArea.route}': () =>
                  PageTransition.makePageTransition(
                    page: const EditHomeView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navLogin.route}': () =>
                  PageTransition.splashTransitionRoute(
                    page: const LoginPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navPersonalArea.route}': () =>
                  PageTransition.makePageTransition(
                    page: const HomePageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navExams.route}': () =>
                  PageTransition.makePageTransition(
                    page: const ExamsPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navStops.route}': () =>
                  PageTransition.makePageTransition(
                    page: const BusStopNextArrivalsPage(),
                    settings: settings,
                  ),
              '/${NavigationItem.navMap.route}': () =>
                  PageTransition.makePageTransition(
                    page: const MapPage(),
                    settings: settings,
                  ),
              '/${NavigationItem.navRestaurants.route}': () =>
                  PageTransition.makePageTransition(
                    page: const RestaurantPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navCalendar.route}': () =>
                  PageTransition.makePageTransition(
                    page: const CalendarPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navLibrary.route}': () =>
                  PageTransition.makePageTransition(
                    page: const LibraryPage(),
                    settings: settings,
                  ),
              '/${NavigationItem.navFaculty.route}': () =>
                  PageTransition.makePageTransition(
                    page: const FacultyPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navAcademicPath.route}': () =>
                  PageTransition.makePageTransition(
                    page: const AcademicPathPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navProfile.route}': () =>
                  PageTransition.makePageTransition(
                    page: const ProfilePageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navBugreport.route}': () =>
                  PageTransition.makePageTransition(
                    page: const BugReportPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navAboutus.route}': () =>
                  PageTransition.makePageTransition(
                    page: const AboutPageView(),
                    settings: settings,
                  ),
              '/${NavigationItem.navCourseUnit.route}': () =>
                  PageTransition.makePageTransition(
                    page: CourseUnitDetailPageView(courseUnit!),
                    settings: settings,
                  ),
            };

            final builder = transitionFunctions[settings.name];
            return builder != null ? builder() : null;
          },
        ),
      ),
    );
  }
}
