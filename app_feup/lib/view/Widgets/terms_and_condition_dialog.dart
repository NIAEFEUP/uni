import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as Constants;

import 'terms_and_conditions.dart';

class TermsAndConditionDialog {
  static Future<void> build(
      BuildContext context, bool didTermsAndConditionChange) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mudança nos Termos e Condições da uni'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      '''Os Termos e Condições da aplicação mudaram desde a última vez que a abriste:'''),
                  TermsAndConditions()
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceito os novos Termos e Condições')),
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/' + Constants.navLogOut,
                          (Route<dynamic> route) => false),
                  child: Text('Rejeito os novos Termos e Condições')),
            ],
          );
        });
  }
}
