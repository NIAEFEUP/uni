import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manages the app section displayed when the user presses the back button
class BackButtonExitWrapper extends StatelessWidget {
  const BackButtonExitWrapper({
    Key? key,
    required this.context,
    required this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget child;

  Future backButton() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Tens a certeza de que pretendes sair?',
                  style: Theme.of(context).textTheme.headline5),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Não'),
                ),
                ElevatedButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: const Text('Sim'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backButton() as Future<bool>,
      child: child,
    );
  }
}
