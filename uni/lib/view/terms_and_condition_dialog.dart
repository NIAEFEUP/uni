import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Mudança nos Termos e Condições da uni',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(child: TermsAndConditions()),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      userTermsDecision
                          .complete(TermsAndConditionsState.accepted);
                      await AppSharedPreferences
                          .setTermsAndConditionsAcceptance(areAccepted: true);
                    },
                    child: const Text(
                      'Aceito',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      userTermsDecision
                          .complete(TermsAndConditionsState.rejected);
                      await AppSharedPreferences
                          .setTermsAndConditionsAcceptance(areAccepted: false);
                    },
                    child: const Text(
                      'Rejeito',
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
