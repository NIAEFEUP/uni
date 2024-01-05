import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/utils/drawer_items.dart';

/// Upper bar of the app.
///
/// This widget consists on an instance of `AppBar` containing the app's logo,
/// an option button and a button with the user's picture.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.getTopRightButton, super.key});

  static const double borderMargin = 18;

  final Widget Function(BuildContext) getTopRightButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  AppBar build(BuildContext context) {
    final queryData = MediaQuery.of(context);

    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: Container(
          color: Theme.of(context).dividerColor,
          margin: const EdgeInsets.only(
            left: borderMargin,
            right: borderMargin,
          ),
          height: 1.5,
        ),
      ),
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: 0,
      title: ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(),
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              final currentRouteName = ModalRoute.of(context)!.settings.name;
              if (currentRouteName != '/${DrawerItem.navPersonalArea.title}') {
                Navigator.pushNamed(
                  context,
                  '/${DrawerItem.navPersonalArea.title}',
                );
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            child: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
              'assets/images/logo_dark.svg',
              height: queryData.size.height / 25,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        getTopRightButton(context),
      ],
    );
  }
}
