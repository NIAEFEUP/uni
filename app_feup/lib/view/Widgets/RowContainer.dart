import 'package:flutter/material.dart';

class RowContainer extends StatelessWidget{
  final Widget child;
  final Color borderColor;
  RowContainer({
    Key key,
    @required this.child,
    this.borderColor
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor == null ? Theme.of(context).accentColor : this.borderColor, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: this.child,
    );
  }

}