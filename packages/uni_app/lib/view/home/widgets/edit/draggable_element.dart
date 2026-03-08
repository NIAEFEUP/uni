import 'package:flutter/material.dart';

class DraggableElement<T extends Object> extends StatelessWidget {
  const DraggableElement({
    super.key,
    required Widget Function(BuildContext context, T data) childBuilder,
    required Widget Function(BuildContext context, T data) feedbackBuilder,
    required this.feedbackSize,
    required this.data,
    this.callback,
  }) : _childBuilder = childBuilder,
       _feedbackBuilder = feedbackBuilder;

  final T data;
  final Widget Function(BuildContext context, T data) _childBuilder;
  final Widget Function(BuildContext context, T data) _feedbackBuilder;
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
        child: ClipRSuperellipse(
          borderRadius: BorderRadius.circular(25),
          child: _feedbackBuilder(context, data),
        ),
      ),
      onDragStarted: () {
        final callback = this.callback;
        if (callback != null) {
          callback();
        }
      },
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(25),
        child: _childBuilder(context, data),
      ),
    );
  }
}
