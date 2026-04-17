import 'package:flutter/material.dart';

class FloorSelectorMenu extends StatelessWidget {
  const FloorSelectorMenu({
    required this.floors,
    required this.selectedFloor,
    required this.onFloorSelected,
    super.key,
  });

  final List<int> floors;
  final int? selectedFloor;
  final void Function(int?) onFloorSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: floors.map((floor) {
          final isSelected = selectedFloor == floor;
          return InkWell(
            onTap: () => onFloorSelected(isSelected ? null : floor),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isSelected
                    ? Theme.of(context).focusColor
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  floor.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSecondary, 
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
