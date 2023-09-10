import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

Widget testableWidget(
  Widget widget, {
  List<ChangeNotifierProvider> providers = const [],
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SessionProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ...providers
    ],
    child: wrapWidget(widget),
  );
}

Widget wrapWidget(Widget widget) {
  return MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  );
}
