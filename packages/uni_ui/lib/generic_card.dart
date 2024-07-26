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
  });

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? shadowColor;
  final double? borderRadius;
  final Function? onClick;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final cardTheme = CardTheme.of(context);

    return Padding(
      padding: margin ?? cardTheme.margin ?? const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () => onClick,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: borderRadius ?? 20,
            cornerSmoothing: 1,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color ??
                  cardTheme.color ??
                  const Color.fromARGB(255, 255, 245, 243),
              boxShadow: [
                BoxShadow(
                  color: shadowColor ??
                      cardTheme.shadowColor ??
                      Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
                padding: padding ?? const EdgeInsets.all(10), child: child),
          ),
        ),
      ),
    );
  }
}
