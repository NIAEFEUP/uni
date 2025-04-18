import 'package:flutter/material.dart';

class AppTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNavbar({
    this.title,
    this.rightButton,
    this.leftButton,
    this.centerTitle = false,
    this.heightSize = const Size.fromHeight(kToolbarHeight),
    super.key,
  });

  final String? title;
  final Widget? rightButton;
  final Widget? leftButton;
  final bool centerTitle;
  final Size heightSize;

  @override
  Size get preferredSize => heightSize;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(leftButton == null ? 5 : 0, 0, 5, 0),
        child: Row(
          children: [
            if (leftButton != null)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: leftButton,
              ),
            Expanded(
              child: centerTitle
                  ? Center(
                      child: Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    )
                  : Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
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
}
