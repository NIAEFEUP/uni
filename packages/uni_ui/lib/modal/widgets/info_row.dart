import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class ModalInfoRow extends StatelessWidget {
  const ModalInfoRow(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      this.optionalIcon = const SizedBox(),
      this.onPressed});

  final String title;
  final String description;
  final UniIcon icon;
  final void Function()? onPressed;
  final Widget optionalIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1))),
        child: Row(
          children: [
            IconButton(onPressed: onPressed, icon: icon),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyMedium!),
                ],
              ),
            ),
            // const Spacer(),
            optionalIcon,
          ],
        ));
  }
}
