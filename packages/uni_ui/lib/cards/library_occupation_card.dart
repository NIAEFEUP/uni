import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/model/entities/library_occupation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LibraryOccupationCard extends StatelessWidget {
  const LibraryOccupationCard({required this.occupation, super.key});

  final LibraryOccupation occupation;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 90,
            lineWidth: 10,
            percent: occupation.percentage / 100,
            center: Text('${occupation.percentage}%',
                style: Theme.of(context).textTheme.displayMedium),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Theme.of(context).colorScheme.surface,
            progressColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: occupation.floors.map((floor) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Floor ${floor.number}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${floor.occupation}/${floor.capacity}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.45,
                        lineHeight: 8.0,
                        percent: floor.percentage / 100,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        progressColor: Theme.of(context).primaryColor,
                        barRadius: const Radius.circular(10),
                        alignment: MainAxisAlignment.start,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
