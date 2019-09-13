import 'package:flutter/material.dart';

class RowContainer extends StatelessWidget{
  final Widget child;
  RowContainer({
    Key key,
    @required this.child
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: this.child,
    );
  }

}