import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/widgets.dart';

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
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1),
          child: _feedbackBuilder(context, data),
        ),
      ),
      onDragStarted: () {
        final callback = this.callback;
        if (callback != null) {
          callback();
        }
      },
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1),
        child: _childBuilder(context, data),
      ),
    );
  }
}
