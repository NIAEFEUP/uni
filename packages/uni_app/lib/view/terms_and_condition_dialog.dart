import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';

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
        return AlertDialog(
          title: Text(
            S.of(context).terms_change,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          content: Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(child: TermsAndConditions()),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      userTermsDecision.complete(
                        TermsAndConditionsState.accepted,
                      );
                      await PreferencesController.setTermsAndConditionsAcceptance(
                        areAccepted: true,
                      );
                    },
                    child: Text(
                      S.of(context).accept,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  FilledButton(
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
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
