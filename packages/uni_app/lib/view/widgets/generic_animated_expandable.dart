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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: AnimatedCrossFade(
        firstCurve: Curves.easeInOutCubic,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        firstChild: widget.firstChild,
        secondChild: widget.secondChild,
        crossFadeState:
            _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    );
  }
}
