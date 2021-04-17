import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/login_page_view.dart';
import 'package:uni/view/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startTimeAndChangeRoute();
  }

  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return  Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: applicationTheme.backgroundColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 4)),
              createTitle(),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                      padding:
                      EdgeInsets.only(bottom: queryData.size.height / 16)),
                  createNILogo(),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 6))
            ],
          )
        ],
      ),
    );
  }

  Widget createTitle() {
    return  ConstrainedBox(
        constraints:  BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: SizedBox(
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              color: Theme.of(context).primaryColor,
            ),
            width: 150.0));
  }

  Widget createNILogo() {
    return SvgPicture.asset(
      'assets/images/by_niaefeup.svg',
      color: Theme.of(context).primaryColor,
      width: queryData.size.width * 0.45,
    );
  }

  void startTimeAndChangeRoute() async {
    Route<Object> nextRoute;
    final Tuple2<String, String> userPersistentInfo =
    await AppSharedPreferences.getPersistentUserInfo();
    final String userName = userPersistentInfo.item1;
    final String password = userPersistentInfo.item2;
    if (userName != '' && password != '') {
      final bool didTermsAndConditionChange =
          await didTermsAndConditionsChange();
      nextRoute = MaterialPageRoute(
          builder: (context) => HomePageView(
              didTermsAndConditionChange: didTermsAndConditionChange));
      StoreProvider.of<AppState>(context)
          .dispatch(reLogin(userName, password, 'feup'));
    } else {
      nextRoute = MaterialPageRoute(builder: (context) => LoginPageView());
    }

    Navigator.pushReplacement(context, nextRoute);
  }

  Future<bool> didTermsAndConditionsChange() async {
    final hash = await AppSharedPreferences.getTermsAndConditionHash();
    if (hash == null) {
      return true;
    }
    final termsAndConditions = await readTermsAndConditions();
    final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
    if (currentHash != hash) {
      await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    }

    return currentHash != hash;
  }
}
