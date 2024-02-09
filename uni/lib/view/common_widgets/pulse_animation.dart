import 'dart:math';
import 'package:flutter/material.dart';

class PulseAnimation extends StatelessWidget {
  const PulseAnimation(
      {super.key, required this.description, required this.controller});
  final String description;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1 - 0.5 * sin(controller.value * pi),
          child: Text(
            description.substring(0, description.indexOf('_')),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
    );
  }
}
