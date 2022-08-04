import 'dart:async';

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
import 'package:uni/view/Pages/logout_route.dart';
import 'package:uni/view/Widgets/terms_and_condition_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

/// Manages the splash screen displayed after a successful login.
class SplashScreenState extends State<SplashScreen> {
  late MediaQueryData queryData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startTimeAndChangeRoute();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 4)),
              createTitle(),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
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

  /// Creates the app Title container with the app's logo.
  Widget createTitle() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: SizedBox(
            width: 150.0,
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              color: Theme.of(context).primaryColor,
            )));
  }

  /// Creates the app main logo
  Widget createNILogo() {
    return SvgPicture.asset(
      'assets/images/by_niaefeup.svg',
      color: Theme.of(context).primaryColor,
      width: queryData.size.width * 0.45,
    );
  }

  // Redirects the user to the proper page depending on his login input.
  void startTimeAndChangeRoute() async {
    MaterialPageRoute<dynamic> nextRoute;
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final String userName = userPersistentInfo.item1;
    final String password = userPersistentInfo.item2;
    if (userName != '' && password != '') {
      nextRoute = await getTermsAndConditions(userName, password);
    } else {
      await acceptTermsAndConditions();
      nextRoute =
          MaterialPageRoute(builder: (context) => const LoginPageView());
    }
    if (!mounted) {
      return;
    }
    Navigator.pushReplacement(context, nextRoute);
  }

  Future<MaterialPageRoute> getTermsAndConditions(
      String userName, String password) async {
    final completer = Completer<TermsAndConditionsState>();
    await TermsAndConditionDialog.build(context, completer, userName, password);
    final state = await completer.future;

    switch (state) {
      case TermsAndConditionsState.accepted:
        if (mounted) {
          final List<String> faculties = StoreProvider.of<AppState>(context)
              .state
              .content['session']
              .faculties;
          StoreProvider.of<AppState>(context)
              .dispatch(reLogin(userName, password, faculties));
        }
        return MaterialPageRoute(builder: (context) => const HomePageView());

      case TermsAndConditionsState.rejected:
        return LogoutRoute.buildLogoutRoute();
    }
  }
}
