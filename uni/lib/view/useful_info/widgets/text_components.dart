import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Container h1(String text, BuildContext context, {bool initial = false}) {
  final double marginTop = initial ? 15.0 : 30.0;
  return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Opacity(
            opacity: 0.8,
            child:
                Text(text, style: Theme.of(context).textTheme.headlineSmall)),
      ));
}

Container h2(String text, BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      ));
}

Container infoText(String text, BuildContext context,
    {bool last = false, link = ''}) {
  final double marginBottom = last ? 8.0 : 0.0;
  return Container(
      margin: EdgeInsets.only(top: 8, bottom: marginBottom, left: 20.0),
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
            onTap: () => link != '' ? launchUrl(Uri.parse(link)) : null),
      ));
}
