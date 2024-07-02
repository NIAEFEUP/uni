import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/locale_notifier.dart';

Future<void> initTestEnvironment() async {
  SharedPreferences.setMockInitialValues({});
  PreferencesController.prefs = await SharedPreferences.getInstance();
  databaseFactory = databaseFactoryFfi;
}

Widget testableWidget(
  Widget widget, {
  List<ChangeNotifierProvider> providers = const [],
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleNotifier>(
        create: (_) => LocaleNotifier(AppLocale.pt),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider()..setState(Profile()),
      ),
      ...providers,
    ],
    child: _wrapWidget(widget),
  );
}

Widget _wrapWidget(Widget widget) {
  return MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    locale: const Locale('pt'),
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: widget,
    ),
  );
}
