import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';

Future<void> initTestEnvironment() async {
  SharedPreferences.setMockInitialValues({});
  PreferencesController.prefs = await SharedPreferences.getInstance();
  FlutterSecureStorage.setMockInitialValues({});
  databaseFactory = databaseFactoryFfi;
}

Widget testableWidget(
  Widget widget, {
  List<ChangeNotifierProvider> providers = const [],
}) {
  return ProviderScope(child: _wrapWidget(widget));
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
    home: Scaffold(body: widget),
  );
}
