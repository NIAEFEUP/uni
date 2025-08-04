import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class GenericExpandable extends StatefulWidget {
  const GenericExpandable({
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final Widget content;

  @override
  State<GenericExpandable> createState() => _GenericExpandableState();
}

class _GenericExpandableState extends State<GenericExpandable> {
  final _controller = ExpandableController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _controller.toggle,
      behavior: HitTestBehavior.translucent,
      child: ExpandablePanel(
        controller: _controller,
        header: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        collapsed: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
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
              child: widget.content,
            ),
          ),
        ),
        expanded: widget.content,
      ),
    );
  }
}
