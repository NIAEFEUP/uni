import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

abstract class GenericExpandable extends StatelessWidget {
  const GenericExpandable(
      {super.key, required this.title, required this.content});

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 20)),
      ),
      collapsed: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.black, Colors.transparent],
          stops: [0.7, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: LimitedBox(
          maxHeight: 100,
          child: content,
        ),
      ),
      expanded: content,
    );
  }
}
