import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';
import 'package:url_launcher/url_launcher.dart';

enum PedagogicalSurveysState { seen, unseen }

class PedagogicalSurveysDialog {
  PedagogicalSurveysDialog._();

  static Future<PedagogicalSurveysState> buildIfPedagogicalSurveysUnseen(
    BuildContext context,
  ) async {
    final shouldShow =
        PreferencesController.shouldShowPedagogicalSurveysDialog();

    final isDismissed = PreferencesController.isPedagogicalSurveysDismissed();

    if (shouldShow) {
      if (isDismissed) {
        return PedagogicalSurveysState.seen;
      }

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
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          title: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UniIcon(UniIcons.chartBar, size: 64),
              Text(
                S.of(context).pedagogical_surveys,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          content: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).pedagogical_surveys_description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  final dontShowAgain =
                      PreferencesController.isPedagogicalSurveysDismissed();
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      await PreferencesController.setPedagogicalSurveysDismissed(
                        dismissed: !dontShowAgain,
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        spacing: 8,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              visualDensity: VisualDensity.compact,
                              value: dontShowAgain,
                              onChanged: (value) async {
                                await PreferencesController.setPedagogicalSurveysDismissed(
                                  dismissed: value ?? false,
                                );
                                setState(() {});
                              },
                            ),
                          ),
                          Text(S.of(context).dont_show_again),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      userSurveySeen.complete(PedagogicalSurveysState.seen);
                    },
                    child: Text(
                      S.of(context).close,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    userSurveySeen.complete(PedagogicalSurveysState.seen);
                    await launchUrl(
                      Uri.parse(
                        'https://sigarra.up.pt/feup/pt/IPUP2016_GERAL.IPUP_INICIO',
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).answer,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
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
