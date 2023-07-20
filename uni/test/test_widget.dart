import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget testableWidget(Widget widget,
    {List<ChangeNotifierProvider> providers = const []}) {
  if (providers.isEmpty) return wrapWidget(widget);

  return MultiProvider(providers: providers, child: wrapWidget(widget));
}

Widget wrapWidget(Widget widget) {
  return MaterialApp(
      home: Scaffold(
    body: widget,
  ));
}
