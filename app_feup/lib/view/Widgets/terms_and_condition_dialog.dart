import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';

import 'terms_and_conditions.dart';

class TermsAndConditionDialog {
  TermsAndConditionDialog._();

  static final successRoute =
      MaterialPageRoute(builder: (context) => HomePageView());
  static final errorRoute = LogoutRoute.buildLogoutRoute();

  static Future<bool> build(
      BuildContext context,
      Completer<MaterialPageRoute> routeCompleter,
      String userName,
      String password) async {
    final didTermsAndConditionChange = await didTermsAndConditionsChange();
    if (didTermsAndConditionChange) {
      SchedulerBinding.instance?.addPostFrameCallback((timestamp) =>
          _buildShowDialog(context, routeCompleter, userName, password));
    } else {
      routeCompleter.complete(successRoute);
    }

    return didTermsAndConditionChange;
  }

  static Future<void> _buildShowDialog(
      BuildContext context,
      Completer<MaterialPageRoute> routeCompleter,
      String userName,
      String password) {
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    StoreProvider.of<AppState>(context)
                        .dispatch(reLogin(userName, password, 'feup'));
                    routeCompleter.complete(successRoute);
                  },
                  child: Text(
                    'Aceito os novos Termos e Condições',
                    style: getTextMethod(context),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    routeCompleter.complete(errorRoute);
                  },
                  child: Text(
                    'Rejeito os novos Termos e Condições',
                    style: getTextMethod(context),
                  )),
            ],
          );
        });
  }

  static TextStyle getTextMethod(BuildContext context) {
    return Theme.of(context).textTheme.headline3.apply(fontSizeDelta: -2);
  }

  static Future<void> storeTermsAndConditionsHash() async {
  }

}
