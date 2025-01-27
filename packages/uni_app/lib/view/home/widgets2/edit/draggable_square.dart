import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/edit/draggable_element.dart';

class DraggableSquare extends StatelessWidget {
  const DraggableSquare({super.key, required this.icon, required this.title});

  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DraggableElement(
      feedback: Container(), // TODO: maybe list tile as well
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
            )
          ],
        ),
      ),
    );
  }
}
