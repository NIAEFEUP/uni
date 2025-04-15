import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';

class DishTypeFilterButton extends StatelessWidget {
  const DishTypeFilterButton({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  final List<Map<String, dynamic>> items;
  final Set<int> selectedValues;
  final void Function(Set<int>) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () => _showFilterDialog(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Dishes',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          const UniIcon(
            UniIcons.caretDown,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final tempSelected = Set<int>.from(selectedValues);
        final allValues = items.map((item) => item['value'] as int).toSet();

        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(tempSelected.clear);
                        },
                        child: const Text('Select None'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            tempSelected.addAll(allValues);
                          });
                        },
                        child: const Text('Select All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...items.map((item) {
                    final value = item['value'] as int;
                    return CheckboxListTile(
                      dense: true,
                      title: Text(
                        S.of(context).dish_type(item['key_label'] as String),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      value: tempSelected.contains(value),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked ?? false) {
                            tempSelected.add(value);
                          } else {
                            tempSelected.remove(value);
                          }
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ],
              );
            },
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            FilledButton(
              onPressed: () {
                onSelectionChanged(tempSelected);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
