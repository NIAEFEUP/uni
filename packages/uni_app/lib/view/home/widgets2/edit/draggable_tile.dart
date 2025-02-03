import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/edit/draggable_element.dart';
import 'package:uni_ui/icons.dart';

class DraggableTile extends StatelessWidget {
  const DraggableTile({
    super.key,
    required this.icon,
    required this.title,
    this.callback,
  });

  final Icon icon;
  final String title;
  final void Function(DraggableTile)? callback;

  void activeCallback() {
    if (callback != null) {
      callback!.call(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableElement(
      callback: activeCallback,
      data: (title, icon),
      feedback: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        width: 75,
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ), // TODO: maybe list tile as well
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: ListTile(
          trailing: const UniIcon(UniIcons.more),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          leading: icon,
        ),
      ),
    );
  }
}
