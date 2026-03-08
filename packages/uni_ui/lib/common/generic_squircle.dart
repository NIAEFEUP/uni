import 'package:flutter/material.dart';

class GenericSquircle extends StatelessWidget {
  const GenericSquircle({super.key, this.borderRadius, required this.child});

  final double? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      child: child,
    );
  }
}
