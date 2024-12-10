import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.label,
    required this.content,
    required this.tooltip,
    this.onClick,
  });

  final String label;
  final String content;
  final String tooltip;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GenericCard(
          tooltip: tooltip,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!,
              ),
              Text(
                content,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (onClick != null)
          Positioned(
            bottom: -4,
            right: 2,
            child: GestureDetector(
              onTap: onClick,
              child: Container(
                child: PhosphorIcon(
                  PhosphorIcons.plus(PhosphorIconsStyle.light),
                  color: Colors.white,
                  size: 14,
                ),
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}