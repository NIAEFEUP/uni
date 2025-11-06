import 'package:flutter/widgets.dart';

class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.minVerticalPadding = 8.0,
    this.dense = false,
  });

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// Called when the user long-presses this list tile.
  final VoidCallback? onLongPress;

  /// The padding for the tile's content.
  final EdgeInsetsGeometry contentPadding;

  /// The minimum vertical padding to ensure the tile has a reasonable height.
  final double minVerticalPadding;

  /// Reduce vertical and horizontal spacing when true.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = dense ? 8.0 : 16.0;
    final verticalPadding = dense ? 4.0 : minVerticalPadding;

    Widget? titleBlock;
    if (title != null || subtitle != null) {
      titleBlock = Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) title!,
            if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: contentPadding,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: horizontalSpacing),
              ],
              if (titleBlock != null) titleBlock,
              if (trailing != null) ...[
                SizedBox(width: horizontalSpacing),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
