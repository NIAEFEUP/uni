import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/utils/drawer_items.dart';

class UniButton extends StatelessWidget {
  const UniButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
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
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset(
            colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
            'assets/images/logo_dark.svg',
            height: 35,
          ),
        ),
      ),
    );
  }
}
