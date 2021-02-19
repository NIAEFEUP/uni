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
          return RichText(
              text: TextSpan(children: linkify(termsAndConditionsSaved)));
        });
  }

  List<TextSpan> linkify(String txt) {
    final RegExp exp = RegExp(
        r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
    final List<TextSpan> lst = List<TextSpan>();
    final textStyle = TextStyle(color: Colors.black);
    final linkStyle =
        TextStyle(color: Colors.black, decoration: TextDecoration.underline);

    for (var line in txt.split('\n')) {
      if (exp.hasMatch(line)) {
        for (var word in line.split(' ')) {
          if (exp.hasMatch(word)) {
            lst.add(TextSpan(
                style: linkStyle,
                text: word + ' ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(exp.firstMatch(word).group(0));
                  }));
          } else {
            lst.add(TextSpan(text: word + ' ', style: textStyle));
          }
        }
      } else {
        lst.add(TextSpan(text: line, style: textStyle));
      }

      lst.add(TextSpan(text: '\n', style: textStyle));
    }
    return lst;
  }
}
