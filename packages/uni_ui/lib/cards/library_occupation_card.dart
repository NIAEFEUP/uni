import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FloorOccupationWidget extends StatelessWidget {
  final String floorText;
  final int floorNumber;
  final int occupation;
  final int capacity;

  const FloorOccupationWidget({
    super.key,
    required this.floorText,
    required this.floorNumber,
    required this.occupation,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${floorText} ${floorNumber}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${occupation}/${capacity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: occupation / capacity,
            backgroundColor: Theme.of(context).colorScheme.surface,
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class LibraryOccupationCard extends StatelessWidget {
  const LibraryOccupationCard({
    super.key,
    required this.occupationMap,
    required this.floorText,
  });

  final Map<String, dynamic> occupationMap;
  final String floorText;

  @override
  Widget build(BuildContext context) {
    final FloorOccupationWidgets =
        (occupationMap["floors"] as List).map((floor) {
      return FloorOccupationWidget(
        floorText: floorText,
        floorNumber: floor["number"],
        occupation: floor["occupation"],
        capacity: floor["capacity"],
      );
    }).toList();

    return GenericCard(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 12,
            percent: occupationMap["occupation"] / occupationMap["capacity"],
            center: Text(
              '${(occupationMap["occupation"] / occupationMap["capacity"] * 100).round()}%',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Theme.of(context).colorScheme.surface,
            progressColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: FloorOccupationWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
