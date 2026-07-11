import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/generic_card.dart';

class TrackingBanner extends StatelessWidget {
  const TrackingBanner(this.onDismiss, {super.key});

  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      tooltip: '',
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).banner_info,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: onDismiss,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
