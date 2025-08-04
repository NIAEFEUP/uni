import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class GenericSquircle extends StatelessWidget {
  const GenericSquircle({super.key, this.borderRadius, required this.child});

  final double? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: borderRadius ?? 20,
        cornerSmoothing: 1,
      ),
      child: child,
    );
  }
}
