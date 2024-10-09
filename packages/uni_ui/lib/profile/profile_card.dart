import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/generic_card.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.label,
    required this.content,
    this.tooltip,
  });

  final String label;
  final String content;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GenericCard(
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
        if (tooltip != null)
          Positioned(
            bottom: -4,
            right: 2,
            child: Tooltip(
              message: tooltip!,
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
