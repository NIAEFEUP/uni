import 'dart:math';
import 'package:flutter/material.dart';

class PulseAnimation extends StatelessWidget {
  const PulseAnimation({
    required this.child,
    required this.controller,
    super.key,
  });
  final Widget child;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Opacity(
          opacity: 1 - 0.5 * sin(controller.value * pi),
          child: child,
        );
      },
    );
  }
}
