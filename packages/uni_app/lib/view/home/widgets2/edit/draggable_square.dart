import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/edit/draggable_element.dart';

class DraggableSquare extends StatelessWidget {
  const DraggableSquare({
    super.key,
    required this.icon,
    required this.title,
    this.callback,
  });

  final Icon icon;
  final String title;
  final void Function(DraggableSquare)? callback;

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
      ),
      child: Container(
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
      ),
    );
  }
}
