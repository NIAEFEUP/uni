import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class ModalDialog extends StatelessWidget {
  const ModalDialog({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipSmoothRect(
          radius: SmoothBorderRadius(cornerRadius: 30, cornerSmoothing: 1),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          )),
    );
  }
}
