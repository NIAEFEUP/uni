import 'package:flutter/material.dart';

class AppTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNavbar({
    this.title,
    this.subtitle,
    this.rightButton,
    this.leftButton,
    this.centerTitle = false,
    this.heightSize,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget? rightButton;
  final Widget? leftButton;
  final bool centerTitle;
  final Size? heightSize;

  @override
  Size get preferredSize => heightSize ?? const Size.fromHeight(kToolbarHeight);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(leftButton == null ? 15 : 0, 0, 5, 0),
        child: Row(
          children: [
            if (leftButton != null)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: leftButton,
              ),
            Expanded(
              child: centerTitle
                  ? Center(child: _buildTitleColumn(context))
                  : _buildTitleColumn(context),
            ),
            if (rightButton == null && centerTitle) const SizedBox(width: 45),
            if (rightButton != null)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: rightButton,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleColumn(BuildContext context) {
    final TextStyle? titleStyle = centerTitle
        ? Theme.of(context).textTheme.headlineLarge
        : Theme.of(context).textTheme.displaySmall;

    final titleWidget = Text(
      title ?? '',
      style: titleStyle,
      overflow: TextOverflow.ellipsis,
    );

    if (subtitle == null || subtitle!.isEmpty) {
      return titleWidget;
    }

    final subtitleWidget = Text(
      subtitle!,
      style:
          Theme.of(context).textTheme.labelSmall ??
          Theme.of(context).textTheme.labelMedium,
      overflow: TextOverflow.ellipsis,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [titleWidget, subtitleWidget],
    );
  }
}
