import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/utils/service_status.dart';

class LiveStatusLabel extends StatelessWidget {
  const LiveStatusLabel({super.key, required this.openingHours});

  final List<String> openingHours;

  @override
  Widget build(BuildContext context) {
    if (openingHours.isEmpty) {
      return const SizedBox.shrink();
    }

    final status = ServiceStatus.getLiveStatus(openingHours);
    if (status == null) {
      return const SizedBox.shrink();
    }

    final String stateText = status.isOpen
        ? S.of(context).open
        : S.of(context).closed;
    final String timeText = status.isOpen
        ? S.of(context).closes_at(status.timeString)
        : S.of(context).opens_at(status.timeString);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: stateText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' · $timeText'),
        ],
      ),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
