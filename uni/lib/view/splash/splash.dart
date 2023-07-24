import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/view/home/home.dart';
import 'package:uni/view/login/login.dart';
import 'package:uni/view/logout_route.dart';
import 'package:uni/view/splash/widgets/terms_and_condition_dialog.dart';
import 'package:uni/view/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

/// Manages the splash screen displayed after the app is launched.
class SplashScreenState extends State<SplashScreen> {
  late MediaQueryData queryData;
  late StateProviders stateProviders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    stateProviders = StateProviders.fromContext(context);
    changeRouteAccordingToLoginAndTerms();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    final systemTheme =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? applicationDarkTheme
            : applicationLightTheme;

    return Theme(
        data: systemTheme,
        child: Builder(
            builder: (context) => Scaffold(
                  body: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(),
                      ),
                      Center(
                        child: createTitle(context),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const CircularProgressIndicator(),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: queryData.size.height / 16)),
                              createNILogo(context),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: queryData.size.height / 15))
                        ],
                      )
                    ],
                  ),
                )));
  }

  /// Creates the app Title container with the app's logo.
  Widget createTitle(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: SizedBox(
            width: 150.0,
            child: SvgPicture.asset('assets/images/logo_dark.svg',
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.srcIn))));
  }

  /// Creates the app main logo
  Widget createNILogo(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/by_niaefeup.svg',
      colorFilter:
          ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
      width: queryData.size.width * 0.45,
    );
  }

  // Redirects the user to the proper page depending on his login input.
  void changeRouteAccordingToLoginAndTerms() async {
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final String userName = userPersistentInfo.item1;
    final String password = userPersistentInfo.item2;

    MaterialPageRoute<dynamic> nextRoute;
    if (userName != '' && password != '') {
      nextRoute =
          await termsAndConditionsRoute(userName, password, stateProviders);
    } else {
      await acceptTermsAndConditions();
      nextRoute =
          MaterialPageRoute(builder: (context) => const LoginPageView());
    }

    if (mounted) {
      Navigator.pushReplacement(context, nextRoute);
    }
  }

  Future<MaterialPageRoute> termsAndConditionsRoute(
      String userName, String password, StateProviders stateProviders) async {
    final termsAcceptance = await TermsAndConditionDialog.buildIfTermsChanged(
        context, userName, password);

    switch (termsAcceptance) {
      case TermsAndConditionsState.accepted:
        if (mounted) {
          final List<String> faculties =
              await AppSharedPreferences.getUserFaculties();
          stateProviders.sessionProvider
              .restoreSession(userName, password, faculties);
        }
        return MaterialPageRoute(builder: (context) => const HomePageView());

      case TermsAndConditionsState.rejected:
        return LogoutRoute.buildLogoutRoute();
    }
  }
}
