import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class DraggableElement extends StatelessWidget {
  const DraggableElement({
    super.key,
    required this.child,
    required this.feedback,
    required this.data,
    this.callback,
  });

  final Widget child;
  final Widget feedback;
  final Object data;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      delay: const Duration(milliseconds: 200),
      data: data,
      feedback: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        child: feedback,
      ),
      onDragStarted: () {
        if (callback != null) {
          callback!.call();
        }
      },
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        child: child,
      ),
    );
  }
}
