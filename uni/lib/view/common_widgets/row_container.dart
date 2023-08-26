import 'package:flutter/material.dart';

/// App default container
class RowContainer extends StatelessWidget {
  const RowContainer({
    required this.child,
    super.key,
    this.borderColor,
    this.color,
  });
  final Widget child;
  final Color? borderColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Theme.of(context).dividerColor,
          width: 0.5,
        ),
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      child: child,
    );
  }
}
