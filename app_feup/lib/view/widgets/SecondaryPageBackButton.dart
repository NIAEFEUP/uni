import 'package:flutter/material.dart';


class SecondaryPageBackButton extends StatelessWidget{
  SecondaryPageBackButton({
    Key key,
    @required this.context,
    @required this.child,
  }):super(key: key);

  final BuildContext context;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: this.child,
      onWillPop: () => this.getNewPage(context),
    );
  }

  Future<void> getNewPage(BuildContext context){
    return Navigator.pushReplacementNamed(context, '/Área Pessoal');
  }
}