import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/pedagogical_surveys_dialog.dart';
import 'package:uni_ui/icons.dart';

class PedagogicalSurveysInfo extends StatelessWidget {
  const PedagogicalSurveysInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      margin: const EdgeInsets.only(right: 65, bottom: 10),
      message: S.of(context).pedagogical_surveys,
      triggerMode: TooltipTriggerMode.longPress,
      waitDuration: Duration.zero,
      showDuration: const Duration(seconds: 2),
      verticalOffset: 18,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      child: InkWell(
        onTap: () {
          PedagogicalSurveysDialog.forceBuild(context);
        },
        child: UniIcon(
          UniIcons.chartBar,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
