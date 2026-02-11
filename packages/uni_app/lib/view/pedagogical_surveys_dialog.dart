import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

enum PedagogicalSurveysState { seen, unseen }

class PedagogicalSurveysDialog {
  PedagogicalSurveysDialog._();

  static Future<PedagogicalSurveysState> buildIfPedagogicalSurveysUnseen(
    BuildContext context,
  ) async {
    final alertWasSeen = PreferencesController.arePedagogicalSurveysSeen();

    if (!alertWasSeen) {
      final routeCompleter = Completer<PedagogicalSurveysState>();
      SchedulerBinding.instance.addPostFrameCallback(
        (timestamp) => _buildShowDialog(context, routeCompleter),
      );
      return routeCompleter.future;
    }

    return PedagogicalSurveysState.seen;
  }

  static Future<void> _buildShowDialog(
    BuildContext context,
    Completer<PedagogicalSurveysState> userSurveySeen,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          title: Text(
            S.of(context).pedagogical_surveys,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).pedagogical_surveys_description,
              ),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  final dontShowAgain =
                      PreferencesController.arePedagogicalSurveysSeen();
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.of(context).dont_show_again,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: dontShowAgain,
                    onChanged: (value) async {
                      await PreferencesController.setPedagogicalSurveysSeen(
                        areSeen: value ?? false,
                      );
                      setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    userSurveySeen.complete(PedagogicalSurveysState.unseen);
                    await PreferencesController.setPedagogicalSurveysSeen(
                      areSeen: false,
                    );
                  },
                  child: Text(
                    S.of(context).close,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await launchUrl(
                      Uri.parse(
                        'https://sigarra.up.pt/feup/pt/IPUP2016_GERAL.IPUP_INICIO',
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).answer,
                    style: TextStyle(fontSize: 12, color: Colors.white),
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
