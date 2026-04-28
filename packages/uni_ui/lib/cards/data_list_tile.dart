import 'package:flutter/material.dart';

class DataListTile extends StatelessWidget {
  const DataListTile({
    super.key,
    required this.prefix,
    required this.text,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.alignPrefix = TextAlign.left,
  });

  final String prefix;
  final String text;
  final TextAlign? alignPrefix;
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
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: alignPrefix,
        ),
        width: 100,
      ),
      title: Text(
        text,
        overflow: TextOverflow.visible,
        softWrap: true,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.left,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
