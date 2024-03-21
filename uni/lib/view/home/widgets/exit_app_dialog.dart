import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

/// Manages the app section displayed when the user presses the back button
class BackButtonExitWrapper extends StatelessWidget {
  const BackButtonExitWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              S.of(context).exit_confirm,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).no),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(S.of(context).yes),
              ),
            ],
          ),
        );
        if ((shouldPop ?? false) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
