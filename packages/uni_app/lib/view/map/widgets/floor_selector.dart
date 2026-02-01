import 'package:flutter/material.dart';
import 'package:uni_ui/theme.dart';

class FloorSelector extends StatelessWidget {
  const FloorSelector({
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
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            floors.map((floor) {
              final isSelected = selectedFloor == floor;
              return InkWell(
                onTap: () => onFloorSelected(isSelected ? null : floor),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isSelected
                            ? Theme.of(context).focusColor
                            : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      floor.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? primaryVibrant : grayText,
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
