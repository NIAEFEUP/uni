import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class DraggableElement<T extends Object> extends StatelessWidget {
  const DraggableElement({
    super.key,
    required this.childBuilder,
    required this.feedbackBuilder,
    required this.feedbackSize,
    required this.data,
    this.callback,
  });

  final T data;
  final Widget Function(BuildContext context, T data) childBuilder;
  final Widget Function(BuildContext context, T data) feedbackBuilder;
  final Offset feedbackSize;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      delay: const Duration(milliseconds: 200),
      data: data,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Transform.translate(
        offset: -feedbackSize / 2,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 1,
          ),
          child: feedbackBuilder(context, data),
        ),
      ),
      onDragStarted: () {
        final callback = this.callback;
        if (callback != null) {
          callback();
        }
      },
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        child: childBuilder(context, data),
      ),
    );
  }
}
