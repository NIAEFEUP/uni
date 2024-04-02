import 'package:flutter/material.dart';

class AnimatedExpandable extends StatefulWidget {
  const AnimatedExpandable({
    required this.firstChild,
    required this.secondChild,
    super.key,
  });

  final Widget firstChild;
  final Widget secondChild;

  @override
  State<StatefulWidget> createState() {
    return AnimatedExpandableState();
  }
}

class AnimatedExpandableState extends State<AnimatedExpandable> {
  bool _expanded = false;

  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      crossFadeState:
          _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
