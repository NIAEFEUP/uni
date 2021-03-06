import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackButtonExitWrapper extends StatelessWidget {
  BackButtonExitWrapper({
    Key key,
    @required this.context,
    @required this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget child;

  Future<bool> backButton() {
    final buttonStyle = ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
    );

    return showDialog(
            context: context,
            builder: (context) =>  AlertDialog(
                  title:  Text('Tens a certeza que pretendes sair?'),
                  actions: <Widget>[
                     ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child:  Text('Não'),
                      style: buttonStyle,
                    ),
                     ElevatedButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child:  Text('Sim'),
                      style: buttonStyle,
                    )
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      child: this.child,
      onWillPop: () => this.backButton(),
    );
  }
}
