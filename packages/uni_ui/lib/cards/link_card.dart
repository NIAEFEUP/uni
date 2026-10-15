import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tooltip,
    this.onTap,
    this.margin = EdgeInsets.zero,
  });

  final UniIconData icon;
  final String title;
  final String subtitle;
  final String tooltip;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;

    return GenericCard(
      tooltip: tooltip,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              UniIcon(icon, size: 30, color: color),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: color),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.open_in_new, size: 25, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
