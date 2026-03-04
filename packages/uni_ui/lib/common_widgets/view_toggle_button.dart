import 'package:flutter/material.dart';

class ViewToggleButton extends StatelessWidget {
  const ViewToggleButton({
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
    super.key,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SegmentedButton<int>(
        segments: List.generate(
          options.length,
          (index) => ButtonSegment<int>(
            value: index,
            label: Text(
              options[index],
              style: const TextStyle(fontSize: 12, height: 1),
            ),
          ),
        ),
        selected: {selected},
        showSelectedIcon: false,
        onSelectionChanged: (Set<int> newSelection) {
          onSelectionChanged(newSelection.first);
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.primaryContainer;
            }
            return Theme.of(context).colorScheme.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.onPrimaryContainer;
            }
            return Theme.of(context).colorScheme.onSurface;
          }),
        ),
      ),
    );
  }
}
