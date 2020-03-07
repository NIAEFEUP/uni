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
    return showDialog(
            context: context,
            builder: (context) =>  AlertDialog(
                  title:  Text('Tens a certeza que pretendes sair?'),
                  actions: <Widget>[
                     RaisedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child:  Text('Não'),
                      color: Theme.of(context).primaryColor,
                    ),
                     RaisedButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child:  Text('Sim'),
                      color: Theme.of(context).primaryColor,
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
