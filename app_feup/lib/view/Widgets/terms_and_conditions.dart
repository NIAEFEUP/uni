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
    List<TextSpan> lst = List<TextSpan>();
    for (var s in txt.split(' ')) {
      if (exp.hasMatch(s)) {
        lst.add(TextSpan(
            text: s + ' ',
            style: TextStyle(color: Colors.blue, fontSize: 20.0),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(exp.firstMatch(s).group(0));
                print("hey!");
              }));
      } else {
        lst.add(TextSpan(text: s + ' ', style: TextStyle(color: Colors.black)));
      }
    }
    return lst;
  }
}
