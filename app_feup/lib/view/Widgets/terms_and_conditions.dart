import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatelessWidget {
  static String termsAndConditionsSaved = 'Carregando os Termos e Condições...';

  @override
  Widget build(BuildContext context) {
    final Future<String> termsAndConditionsFuture = readTermsAndConditions();
    return FutureBuilder(
        future: termsAndConditionsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<String> termsAndConditions) {
          if (termsAndConditions.connectionState == ConnectionState.done &&
              termsAndConditions.hasData) {
            termsAndConditionsSaved = termsAndConditions.data;
          }
          return MarkdownBody(
            styleSheet: MarkdownStyleSheet(),
            shrinkWrap: false,
            data: termsAndConditionsSaved,
            onTapLink: (text, url, title) async {
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          );
        });
  }
}
