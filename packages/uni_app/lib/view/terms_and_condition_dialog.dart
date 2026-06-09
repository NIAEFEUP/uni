import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';
import 'package:uni_ui/modal/modal.dart';

enum TermsAndConditionsState { accepted, rejected }

class TermsAndConditionDialog {
  TermsAndConditionDialog._();

  static Future<TermsAndConditionsState> buildIfTermsChanged(
    BuildContext context,
  ) async {
    final termsAreAccepted =
        await updateTermsAndConditionsAcceptancePreference();

    if (!termsAreAccepted) {
      final routeCompleter = Completer<TermsAndConditionsState>();
      SchedulerBinding.instance.addPostFrameCallback(
        (timestamp) => _buildShowDialog(context, routeCompleter),
      );
      return routeCompleter.future;
    }

    return TermsAndConditionsState.accepted;
  }

  static Future<void> _buildShowDialog(
    BuildContext context,
    Completer<TermsAndConditionsState> userTermsDecision,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ModalDialog(
          children: [
            Text(
              S.of(context).terms_change,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(child: TermsAndConditions()),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    userTermsDecision.complete(
                      TermsAndConditionsState.rejected,
                    );
                    await PreferencesController.setTermsAndConditionsAcceptance(
                      areAccepted: false,
                    );
                  },
                  child: Text(
                    S.of(context).reject,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    userTermsDecision.complete(
                      TermsAndConditionsState.accepted,
                    );
                    await PreferencesController.setTermsAndConditionsAcceptance(
                      areAccepted: true,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  child: Text(
                    S.of(context).accept,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
