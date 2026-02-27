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
    return SegmentedButton<int>(
      segments: List.generate(
        options.length,
        (index) =>
            ButtonSegment<int>(value: index, label: Text(options[index])),
      ),
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (Set<int> newSelection) {
        onSelectionChanged(newSelection.first);
      },
      style: ButtonStyle(
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
    );
  }
}
