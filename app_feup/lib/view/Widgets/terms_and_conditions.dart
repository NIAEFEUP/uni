import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

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
          return linkify(termsAndConditionsSaved);
        });
  }

  Text linkify(String txt) {
    final RegExp linkExp = RegExp(
        r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
    final RegExp emailExp = RegExp(r'\w+@\w+.\w+');
    final List<TextSpan> lst = List<TextSpan>();

    for (String line in txt.split('\n')) {
      if (linkExp.hasMatch(line) || emailExp.hasMatch(line)) {
        for (String word in line.split(' ')) {
          if (linkExp.hasMatch(word) || emailExp.hasMatch(word)) {
            lst.add(TextSpan(
                style: TextStyle(fontStyle: FontStyle.italic),
                text: word + ' ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final link = linkExp.hasMatch(word)
                        ? linkExp.firstMatch(word).group(0)
                        : 'mailto:' + emailExp.firstMatch(word).group(0);
                    if (await canLaunch(link)) {
                      launch(link);
                    }
                  }));
          } else {
            lst.add(TextSpan(text: word + ' '));
          }
        }
      } else {
        lst.add(TextSpan(text: line));
      }

      lst.add(TextSpan(text: '\n'));
    }
    return Text.rich(TextSpan(children: lst));
  }
}
