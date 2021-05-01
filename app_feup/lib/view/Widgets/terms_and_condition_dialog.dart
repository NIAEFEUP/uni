import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

import 'terms_and_conditions.dart';

enum TermsAndConditionsState { accepted, rejected }

class TermsAndConditionDialog {
  TermsAndConditionDialog._();

  static Future<bool> build(
      BuildContext context,
      Completer<TermsAndConditionsState> routeCompleter,
      String userName,
      String password) async {
    final acceptance = await updateTermsAndConditionsAcceptancePreference();
    if (acceptance) {
      SchedulerBinding.instance?.addPostFrameCallback((timestamp) =>
          _buildShowDialog(context, routeCompleter, userName, password));
    } else {
      routeCompleter.complete(TermsAndConditionsState.accepted);
    }

    return acceptance;
  }

  static Future<void> _buildShowDialog(
      BuildContext context,
      Completer<TermsAndConditionsState> routeCompleter,
      String userName,
      String password) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mudança nos Termos e Condições da uni'),
            content: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                              '''Os Termos e Condições da aplicação mudaram desde a última vez que a abriste:'''),
                        ),
                        TermsAndConditions()
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          routeCompleter
                              .complete(TermsAndConditionsState.accepted);
                          await AppSharedPreferences
                              .setTermsAndConditionsAcceptance(true);
                        },
                        child: Text(
                          'Aceito os novos Termos e Condições',
                          style: getTextMethod(context),
                        )),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          routeCompleter
                              .complete(TermsAndConditionsState.rejected);
                          await AppSharedPreferences
                              .setTermsAndConditionsAcceptance(false);
                        },
                        child: Text(
                          'Rejeito os novos Termos e Condições',
                          style: getTextMethod(context),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  static TextStyle getTextMethod(BuildContext context) {
    return Theme.of(context).textTheme.headline3.apply(fontSizeDelta: -2);
  }
}
