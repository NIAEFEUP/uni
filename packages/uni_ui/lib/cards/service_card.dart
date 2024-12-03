import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.name,
    required this.openingHours,
  });

  final String name;
  final List<String> openingHours;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall!,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PhosphorIcon(
                PhosphorIcons.clock(PhosphorIconsStyle.duotone),
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 20,
              ),
              const SizedBox(width: 5),
              Column(
                children: openingHours.map((hour) {
                  return Text(
                    hour,
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }).toList(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
