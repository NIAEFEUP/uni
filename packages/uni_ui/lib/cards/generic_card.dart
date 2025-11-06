import 'package:flutter/widgets.dart';
import 'package:uni_ui/common/generic_squircle.dart';
import 'package:uni_ui/theme.dart';
import 'package:flutter/foundation.dart';

class GenericCard extends StatelessWidget {
  const GenericCard({
    super.key,
    this.margin,
    this.padding,
    this.color,
    this.shadowColor,
    this.borderRadius,
    this.onClick,
    this.child,
    this.gradient,
    required this.tooltip,
  });

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? shadowColor;
  final double? borderRadius;
  final VoidCallback? onClick;
  final Widget? child;
  final Gradient? gradient;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // TODO: add tooltip to generic card
      margin: margin ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.grayMiddle,
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onClick,
        child: GenericSquircle(
          child: Container(
            decoration: BoxDecoration(
              color: color ?? theme.secondary,
              gradient: gradient,
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(10),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
