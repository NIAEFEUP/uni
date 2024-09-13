import 'dart:async';

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
    // ignore: deprecated_member_use, see #1209
    return WillPopScope(
      onWillPop: () {
        final userActionCompleter = Completer<bool>();
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              S.of(context).exit_confirm,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  userActionCompleter.complete(false);
                  Navigator.of(context).pop(false);
                },
                child: Text(S.of(context).no),
              ),
              ElevatedButton(
                onPressed: () {
                  userActionCompleter.complete(true);
                  Navigator.of(context).pop(false);
                },
                child: Text(S.of(context).yes),
              ),
            ],
          ),
        );
        return userActionCompleter.future;
      },
      child: child,
    );
  }
}
