import 'package:flutter/material.dart';

/// Upper bar of the app.
///
/// This widget consists on an instance of `AppBar` containing the app's logo,
/// an option button and a button with the user's picture.
class AppTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNavbar({
    this.title,
    this.rightButton,
    this.leftButton,
    super.key,
  });

  static const double borderMargin = 18;

  final String? title;
  final Widget? rightButton;
  final Widget? leftButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: 0,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: leftButton,
          ),
          Center(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context)
                        .primaryTextTheme
                        .headlineMedium
                        ?.color,
                  ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: rightButton,
          ),
        ],
      ),
    );
  }
}
