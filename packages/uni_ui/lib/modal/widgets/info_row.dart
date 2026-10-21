import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class ModalInfoRow extends StatelessWidget {
  const ModalInfoRow({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget,   // novo
    required this.icon,
    this.trailing = const SizedBox(),
    this.onPressed,
});

  final String title;
  final String? description;
  final Widget? descriptionWidget;
  final UniIconData icon;
  final void Function()? onPressed;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryFixed,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        dense: true,
        leading: UniIcon(
          icon,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: descriptionWidget ??
    (description != null
        ? Text(description!, style: Theme.of(context).textTheme.bodyMedium)
        : null),
        trailing: trailing,
        onTap: onPressed,
      ),
    );
  }
}
