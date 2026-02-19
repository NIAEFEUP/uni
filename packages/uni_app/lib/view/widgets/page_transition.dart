import 'package:flutter/material.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/pedagogical_surveys_dialog.dart';
import 'package:uni/view/terms_and_condition_dialog.dart';

/// Transition used between pages
class PageTransition {
  static const pageTransitionDuration = 200;
  static var _isFirstPageTransition = true;

  static Route<Widget> makePageTransition({
    required Widget page,
    required RouteSettings settings,
    bool maintainState = true,
    bool checkTermsAndConditions = true,
    bool checkPedagogicalSurveys = true,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        if (_isFirstPageTransition) {
          _isFirstPageTransition = false;
          if (checkTermsAndConditions) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => requestTermsAndConditionsAcceptanceIfNeeded(context),
            );
          }
          if (checkPedagogicalSurveys) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => requestPedagogicalSurveysIfNeeded(context),
            );
          }
        }

        return page;
      },
      transitionDuration: const Duration(milliseconds: pageTransitionDuration),
      settings: settings,
      maintainState: maintainState,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<Widget> splashTransitionRoute({
    required Widget page,
    required RouteSettings settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: settings,
      maintainState: maintainState,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Future<void> requestTermsAndConditionsAcceptanceIfNeeded(
    BuildContext context,
  ) async {
    if (context.mounted) {
      final termsAcceptance = await TermsAndConditionDialog.buildIfTermsChanged(
        context,
      );

      switch (termsAcceptance) {
        case TermsAndConditionsState.accepted:
          return;
        case TermsAndConditionsState.rejected:
          await NetworkRouter.authenticationController?.close();
      }
    }
  }

  static Future<void> requestPedagogicalSurveysIfNeeded(
    BuildContext context,
  ) async {
    if (context.mounted) {
      final pedagogicalSurveysState =
          await PedagogicalSurveysDialog.buildIfPedagogicalSurveysUnseen(
            context,
          );

      switch (pedagogicalSurveysState) {
        case PedagogicalSurveysState.seen:
          return;
        case PedagogicalSurveysState.unseen:
          return;
      }
    }
  }
}
