import 'package:flutter/material.dart';
import 'package:uni/utils/navigation_items.dart';

class DrawerNavigationOption extends StatelessWidget {
  const DrawerNavigationOption({required this.item, super.key});

  final NavigationItem item;

  String getCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)!.settings.name == null
          ? NavigationItem.values.toList()[0].route
          : ModalRoute.of(context)!.settings.name!.substring(1);

  void onSelectPage(String key, BuildContext context) {
    final prev = getCurrentRoute(context);

    Navigator.of(context).pop();

    if (prev != key) {
      Navigator.pushNamed(context, '/$key');
    }
  }

  BoxDecoration? _getSelectionDecoration(String name, BuildContext context) {
    return (name == getCurrentRoute(context))
        ? BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            color: Theme.of(context).dividerColor,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          _getSelectionDecoration(item.route, context) ?? const BoxDecoration(),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(bottom: 3, left: 20),
          child: Text(
            item.route,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        dense: true,
        contentPadding: EdgeInsets.zero,
        selected: item.route == getCurrentRoute(context),
        onTap: () => onSelectPage(item.route, context),
      ),
    );
  }
}
