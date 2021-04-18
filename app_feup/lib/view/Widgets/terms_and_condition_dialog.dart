import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';

import 'terms_and_conditions.dart';

class TermsAndConditionDialog {
  TermsAndConditionDialog._();

  static final successRoute =
      MaterialPageRoute(builder: (context) => HomePageView());
  static final errorRoute = LogoutRoute.buildLogoutRoute();

  static Future<void> build(
      BuildContext context, Completer<MaterialPageRoute> routeCompleter) async {
    final didTermsAndConditionChange = await _didTermsAndConditionsChange();
    if (didTermsAndConditionChange) {
      SchedulerBinding.instance?.addPostFrameCallback(
          (timestamp) => _buildShowDialog(context, routeCompleter));
    } else {
      routeCompleter.complete(successRoute);
    }
  }

  static Future<void> _buildShowDialog(
      BuildContext context, Completer<MaterialPageRoute> routeCompleter) {
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
                  onPressed: () => routeCompleter.complete(successRoute),
                  child: Text('Aceito os novos Termos e Condições')),
              TextButton(
                  onPressed: () => routeCompleter.complete(errorRoute),
                  child: Text('Rejeito os novos Termos e Condições')),
            ],
          );
        });
  }

  static Future<bool> _didTermsAndConditionsChange() async {
    final hash = await AppSharedPreferences.getTermsAndConditionHash();
    final termsAndConditions = await readTermsAndConditions();
    final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
    if (hash == null) {
      await AppSharedPreferences.setTermsAndConditionHash(currentHash);
      return true;
    }

    if (currentHash != hash) {
      await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    }

    return currentHash != hash;
  }
}
