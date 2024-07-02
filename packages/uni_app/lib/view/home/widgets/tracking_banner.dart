import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class TrackingBanner extends StatelessWidget {
  const TrackingBanner(this.onDismiss, {super.key});

  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
      ),
      margin: const EdgeInsets.all(10),
      child: MaterialBanner(
        padding: const EdgeInsets.all(15),
        content: Text(
          S.of(context).banner_info,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          TextButton(
            onPressed: onDismiss,
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
