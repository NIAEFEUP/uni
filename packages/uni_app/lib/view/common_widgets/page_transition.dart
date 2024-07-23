import 'package:flutter/material.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/terms_and_condition_dialog.dart';

/// Transition used between pages
class PageTransition {
  static const int pageTransitionDuration = 200;
  static bool _isFirstPageTransition = true;

  static Route<Widget> makePageTransition({
    required Widget page,
    required RouteSettings settings,
    bool maintainState = true,
    bool checkTermsAndConditions = true,
  }) {
    return PageRouteBuilder(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        if (_isFirstPageTransition) {
          _isFirstPageTransition = false;
          if (checkTermsAndConditions) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => requestTermsAndConditionsAcceptanceIfNeeded(context),
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
          NavigationService.logoutAndPopHistory();
      }
    }
  }
}
