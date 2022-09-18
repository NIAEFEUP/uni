import 'package:flutter/material.dart';

/// App default container
class RowContainer extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final Color? color;
  const RowContainer(
      {Key? key, required this.child, this.borderColor, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Theme.of(context).dividerColor, width: 0.5),
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      child: child,
    );
  }
}
