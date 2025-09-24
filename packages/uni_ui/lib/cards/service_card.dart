import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.name,
    required this.openingHours,
    required this.tooltip,
    this.function,
  });

  final void Function(BuildContext)? function;
  final String name;
  final List<String> openingHours;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x3f),
      blurRadius: 5,
      key: key,
      tooltip: tooltip,
      onClick: () => function?.call(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment:
                openingHours.length == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style:
                      openingHours.length == 0
                          ? Theme.of(context).textTheme.headlineMedium!
                          : Theme.of(context).textTheme.headlineSmall!,
                ),
              ),
            ],
          ),
          Column(
            children:
                openingHours.length == 0
                    ? []
                    : [
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UniIcon(
                            UniIcons.clock,
                            color: Theme.of(context).shadowColor,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  openingHours.map((hour) {
                                    return Text(
                                      hour,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
          ),
        ],
      ),
    );
  }
}
