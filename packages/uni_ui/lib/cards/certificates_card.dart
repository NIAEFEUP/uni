import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

class CertificatesCard extends StatelessWidget {
  const CertificatesCard({
    required this.type,
    required this.subtitle,
    required this.delivered,
    required this.canceled,
    this.onTap,
    super.key,
  });

  final String type;
  final String subtitle;
  final bool delivered;
  final bool canceled;
  final VoidCallback? onTap;

  bool get _pending => !delivered && !canceled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GenericCard(
      key: key,
      tooltip: type,
      margin: EdgeInsets.zero,
      shadowColor: theme.colorScheme.shadow.withAlpha(0x25),
      blurRadius: 1,
      onClick: onTap,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 20, 12),
      child: SizedBox(
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UniIcon(
              _stateIcon,
              color: theme.colorScheme.onSecondary,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: theme.textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _stateIcon {
    if (canceled) {
      return UniIcons.closed;
    }
    if (_pending) {
      return UniIcons.hourglass;
    }
    return UniIcons.thumbsUp;
  }
}
