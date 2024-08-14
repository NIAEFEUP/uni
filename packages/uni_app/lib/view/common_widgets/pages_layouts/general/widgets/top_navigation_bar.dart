import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/page_title.dart';

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

  Widget _createTopWidgets(BuildContext context) {
    final shouldShowDivider = title == 'Faculty' || title == 'Restaurants';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(leftButton == null ? 20 : 12, 0, 20, 0),
          child: Row(
            children: [
              if (leftButton != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: leftButton,
                ),
              Expanded(
                child: PageTitle(
                  name: title ?? '',
                  pad: false,
                  center: false,
                ),
              ),
              if (rightButton != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: rightButton,
                ),
            ],
          ),
        ),
        if (shouldShowDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Container(
              height: 1,
              color: const Color(0xFF7F7F7F),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).dividerColor,
      surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
      titleSpacing: 0,
      title: _createTopWidgets(context),
    );
  }
}
