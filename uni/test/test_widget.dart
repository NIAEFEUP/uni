import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/locale_notifier.dart';

Widget testableWidget(
  Widget widget, {
  List<ChangeNotifierProvider> providers = const [],
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleNotifier>(
        create: (_) => LocaleNotifier(const Locale('pt')),
      ),
      ...providers
    ],
    child: wrapWidget(widget),
  );
}

Widget wrapWidget(Widget widget) {
  return MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: widget,
    ),
  );
}
