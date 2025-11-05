import 'package:flutter/widgets.dart';
import 'package:uni_ui/icons.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UniIcon(icon, color: Theme.of(context).primaryVibrant),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).headlineSmall,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
