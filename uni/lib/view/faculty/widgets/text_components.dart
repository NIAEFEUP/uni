import 'package:flutter/material.dart';
import 'package:uni/controller/networking/url_launcher.dart';

Container h1(String text, BuildContext context, {bool initial = false}) {
  final marginTop = initial ? 15.0 : 30.0;
  return Container(
    margin: EdgeInsets.only(top: marginTop, left: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Opacity(
        opacity: 0.8,
        child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
      ),
    ),
  );
}

Container h2(String text, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 13, left: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

Container infoText(
  String text,
  BuildContext context, {
  bool last = false,
  String link = '',
}) {
  final marginBottom = last ? 8.0 : 0.0;
  return Container(
    margin: EdgeInsets.only(top: 8, bottom: marginBottom, left: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .apply(color: Theme.of(context).colorScheme.tertiary),
        ),
        onTap: () => launchUrlWithToast(context, link),
      ),
    ),
  );
}
