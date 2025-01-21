import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing, 
      onTap: onTap,
    );
  }
}