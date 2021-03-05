import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsAndConditions extends StatelessWidget {
  static String termsAndConditionsSaved = 'Carregando os Termos e Condições...';

  @override
  Widget build(BuildContext context) {
    final Future<String> termsAndConditionsFuture = readTermsAndConditions();
    return FutureBuilder(
        future: termsAndConditionsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<String> termsAndConditions) {
          if (termsAndConditions.connectionState == ConnectionState.done) {
            termsAndConditionsSaved = termsAndConditions.data;
          }
          return MarkdownBody(
            styleSheet: MarkdownStyleSheet(
              // Once we upgrade to the current stable version of Flutter,
              // this should be passed through 'headline1' property in ThemeData
              h1: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            shrinkWrap: false,
            data: termsAndConditionsSaved,
            onTapLink: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          );
        });
  }
}
