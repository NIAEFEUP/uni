import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class DataListTile extends StatelessWidget {
  const DataListTile({
    super.key,
    required this.prefix,
    required this.text,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String prefix;
  final String text;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        child: Text(
          prefix,
          overflow: TextOverflow.visible,
          softWrap: true,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.right,
        ),
        width: 90,
      ),
      title: Text(
        text,
        overflow: TextOverflow.visible,
        softWrap: true,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.left,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
