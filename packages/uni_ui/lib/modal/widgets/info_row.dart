import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class ModalInfoRow extends StatelessWidget {
  const ModalInfoRow({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.trailing = const SizedBox(),
    this.onPressed,
  });

  final String title;
  final String? description;
  final IconData icon;
  final void Function()? onPressed;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: ListTile(
        dense: true,
        // visualDensity: VisualDensity(vertical: -4),
        leading: UniIcon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: description != null
            ? Text(description!, style: Theme.of(context).textTheme.bodyMedium)
            : null,
        trailing: trailing,
        onTap: onPressed,
      ),
    );
  }
}
