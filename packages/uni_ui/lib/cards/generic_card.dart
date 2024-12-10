import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

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
    required this.tooltip,
  });

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? shadowColor;
  final double? borderRadius;
  final Function? onClick;
  final Widget? child;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final cardTheme = CardTheme.of(context);
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: Container(
        margin: margin ?? cardTheme.margin ?? const EdgeInsets.all(4),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor ??
                  cardTheme.shadowColor ??
                  Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: borderRadius ?? 20,
            cornerSmoothing: 1,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color ??
                  cardTheme.color ??
                  theme.colorScheme.surfaceContainer,
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: onClick != null ? () => onClick!() : null,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
