import 'package:flutter/material.dart';
import 'package:uni_ui/model/entities/library_occupation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LibraryOccupationCard extends StatelessWidget {
  const LibraryOccupationCard({required this.occupation, super.key});

  final LibraryOccupation occupation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(0x1c, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CircularPercentIndicator(
                  radius: 90,
                  lineWidth: 10,
                  percent: occupation.percentage / 100,
                  center: Text('${occupation.percentage}%',
                      style: Theme.of(context).textTheme.displayMedium),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  progressColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: occupation.floors.map((floor) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
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
        ),
      ),
    );
  }
}
