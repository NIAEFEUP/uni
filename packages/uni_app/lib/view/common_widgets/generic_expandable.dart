import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class GenericExpandable extends StatelessWidget {
  const GenericExpandable({
    required this.title,
    required this.content,
    super.key,
  });

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
        child: ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.25,
            child: content,
          ),
        ),
      ),
      expanded: content,
    );
  }
}
