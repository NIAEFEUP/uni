import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/generated/l10n.dart';

/// Manages the app section displayed when the user presses the back button
class BackButtonExitWrapper extends StatelessWidget {
  const BackButtonExitWrapper({
    required this.context,
    required this.child,
    super.key,
  });

  final BuildContext context;
  final Widget child;

  Future<void> backButton() {
    return showDialog<void>(
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
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text(S.of(context).yes),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backButton() as Future<bool>,
      child: child,
    );
  }
}
