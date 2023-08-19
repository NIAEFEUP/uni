import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';

Widget testableWidget(
  Widget widget, {
  List<ChangeNotifierProvider> providers = const [],
}) {
  if (providers.isEmpty) return wrapWidget(widget);

  return MultiProvider(providers: providers, child: wrapWidget(widget));
}

Widget wrapWidget(Widget widget) {
  return MaterialApp(
    home: Scaffold(
      body: Localizations(
        delegates: const [
          S.delegate,
        ],
        locale: const Locale('pt'),
        child: widget,
      ),
    ),
  );
}
