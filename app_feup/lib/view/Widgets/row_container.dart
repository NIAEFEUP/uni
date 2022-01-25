import 'package:flutter/material.dart';

class RowContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color color;
  RowContainer({Key key, @required this.child, this.borderColor, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor == null
                  ? Theme.of(context).dividerColor
                  : this.borderColor,
              width: 0.5),
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: this.child,
    );
  }
}
