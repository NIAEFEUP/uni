import 'package:flutter/material.dart';

enum ArrowPosition { left, right, bottom, bottomRight, bottomLeft }

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    required this.margin,
    required this.content,
    required this.expandedContent,
    this.arrowPosition = ArrowPosition.bottom,
    this.animationCurve = Curves.fastEaseInToSlowEaseOut,
    this.animationDuration = const Duration(milliseconds: 300),
    super.key,
  });

  final EdgeInsetsGeometry margin;

  final Widget content;
  final Widget expandedContent;
  final ArrowPosition arrowPosition;
  final Curve animationCurve;
  final Duration animationDuration;

  @override
  State<StatefulWidget> createState() => ExpandableCardState();
}

class ExpandableCardState extends State<ExpandableCard>
    with TickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: widget.animationCurve,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.margin,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(0x1c, 0, 0, 0),
              blurRadius: 7,
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 60,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            width: double.infinity,
            child: Column(
              children: _buildCardContent(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardContent() {
    switch (widget.arrowPosition) {
      case ArrowPosition.left:
        return [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _arrowIcon(),
              widget.content,
            ],
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: widget.expandedContent,
          )
        ];
      case ArrowPosition.right:
        return [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [widget.content, _arrowIcon()],
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: widget.expandedContent,
          )
        ];
      case ArrowPosition.bottom:
        return [
          widget.content,
          SizeTransition(
            sizeFactor: _animation,
            child: widget.expandedContent,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  child: _arrowIcon(),
                ),
              ),
            ],
          )
        ];
      case ArrowPosition.bottomLeft:
        return [
          widget.content,
          SizeTransition(
            sizeFactor: _animation,
            child: widget.expandedContent,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _arrowIcon(),
                ),
              ),
            ],
          ),
        ];
      case ArrowPosition.bottomRight:
        return [
          widget.content,
          SizeTransition(
            sizeFactor: _animation,
            child: widget.expandedContent,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _arrowIcon(),
                ),
              )
            ],
          ),
        ];
    }
  }

  Widget _arrowIcon() => IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            _expanded = !_expanded;
          });
        },
        icon: Icon(
          _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
      );
}
