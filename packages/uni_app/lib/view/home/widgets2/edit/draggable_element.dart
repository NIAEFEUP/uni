import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class DraggableElement extends StatelessWidget {
  const DraggableElement({
    super.key,
    required this.child,
    required this.feedback,
  });

  final Widget child;
  final Widget feedback;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: feedback,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 1,
          ),
          child: child,
        ),
      ),
    );
  }
}
