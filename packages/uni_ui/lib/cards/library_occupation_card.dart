import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LibraryOccupationCard extends StatelessWidget {
  const LibraryOccupationCard(
      {super.key, required this.occupation_map, required this.floorText});
  final Map<String, dynamic> occupation_map;
  final String floorText;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 12,
            percent: occupation_map["occupation"] / occupation_map["capacity"],
            center: Text(
              '${(occupation_map["occupation"] / occupation_map["capacity"] * 100).round()}%',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Theme.of(context).colorScheme.surface,
            progressColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: occupation_map["floors"].map<Widget>((floor) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${floorText} ${floor["number"]}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${floor["occupation"]}/${floor["capacity"]}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          LinearPercentIndicator(
                            width: constraints.maxWidth,
                            lineHeight: 8.0,
                            percent: floor["occupation"] / floor["capacity"],
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            progressColor: Theme.of(context).primaryColor,
                            barRadius: const Radius.circular(10),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
