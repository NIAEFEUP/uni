import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ModalInfoRow extends StatelessWidget {
  const ModalInfoRow(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      this.onPressed});

  final String title;
  final String description;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(description,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).secondaryHeaderColor)),
                ],
              ),
            ),
            IconButton(onPressed: onPressed, icon: PhosphorIcon(icon))
          ],
        ));
  }
}
