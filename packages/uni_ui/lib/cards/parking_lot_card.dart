import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ParkingLotRowWidget extends StatelessWidget {
  const ParkingLotRowWidget({
    super.key,
    required this.lotId,
    required this.lotName,
    required this.free,
    required this.capacity,
  });

  final String lotId;
  final String lotName;
  final int free;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final occupied = capacity - free;
    final ratio = capacity > 0 ? (occupied / capacity).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$lotId  ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: lotName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '$free livre${free == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: ratio,
            backgroundColor: const Color.fromRGBO(177, 77, 84, 0.25),
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class ParkingLotCard extends StatelessWidget {
  const ParkingLotCard({super.key, required this.lots});

  /// Each entry: (lotId, lotName, free, capacity)
  final List<ParkingLotRowWidget> lots;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.zero,
      tooltip: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lots,
      ),
    );
  }
}
