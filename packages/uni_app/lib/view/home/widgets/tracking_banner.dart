import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/theme.dart';

class TrackingBanner extends StatelessWidget {
  const TrackingBanner(this.onDismiss, {super.key});

  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryVibrant
                : Theme.of(context).cardColor,
      ),
      margin: const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
      child: MaterialBanner(
        padding: const EdgeInsets.all(15),
        content: Text(
          S.of(context).banner_info,
          style: const TextStyle(color: white),
        ),
        backgroundColor: transparent,
        actions: <Widget>[
          TextButton(
            onPressed: onDismiss,
            child: const Text('OK', style: TextStyle(color: white)),
          ),
        ],
      ),
    );
  }
}
