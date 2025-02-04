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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: openingHours.length == 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    name,
                    softWrap: true,
                    style: openingHours.length == 0
                        ? Theme.of(context).textTheme.headlineMedium!
                        : Theme.of(context).textTheme.headlineSmall!,
                  ),
                ),
              ],
            ),
            Column(
              children: openingHours.length == 0
                  ? []
                  : [
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.clock(PhosphorIconsStyle.duotone),
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
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
          ]),
    );
  }
}
