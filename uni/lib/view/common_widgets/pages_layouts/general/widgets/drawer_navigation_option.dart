import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';

class DrawerNavigationOption extends StatelessWidget {
  const DrawerNavigationOption({required this.item, super.key});

  final DrawerItem item;

  String getCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)!.settings.name == null
          ? DrawerItem.values.toList()[0].title
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
          _getSelectionDecoration(item.title, context) ?? const BoxDecoration(),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(bottom: 3, left: 20),
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        dense: true,
        contentPadding: EdgeInsets.zero,
        selected: item.title == getCurrentRoute(context),
        onTap: () => onSelectPage(item.title, context),
      ),
    );
  }
}
