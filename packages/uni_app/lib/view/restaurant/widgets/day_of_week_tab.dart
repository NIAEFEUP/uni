import 'package:flutter/material.dart';

class DayOfWeekTab extends StatelessWidget {
  const DayOfWeekTab({
    super.key,
    required this.isSelected,
    required this.weekDay,
    required this.day,
  });

  final bool isSelected;
  final String weekDay;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 45,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekDay,
            style: isSelected
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Text(
            day,
            style: isSelected
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
