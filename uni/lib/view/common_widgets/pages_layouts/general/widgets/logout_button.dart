import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _onLogOut(String key, BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/$key', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final logOutText = DrawerItem.navLogOut.title;
    return TextButton(
      onPressed: () => _onLogOut(logOutText, context),
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 5),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          logOutText,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
