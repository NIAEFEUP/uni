import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';

class DishTypeCheckboxMenu extends StatelessWidget {
  const DishTypeCheckboxMenu({
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
            S.of(context).dish_types,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          const UniIcon(
            UniIcons.caretDownRegular,
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

        return StatefulBuilder(
          builder: (context, setState) {
            final isAllSelected = tempSelected.length == allValues.length;

            void toggleSelectAll(bool? isChecked) {
              setState(() {
                if (isChecked ?? false) {
                  tempSelected.addAll(allValues);
                } else {
                  tempSelected.clear();
                }
              });
            }

            return ModalDialog(
              children: [
                CheckboxListTile(
                  title: Text(
                    S.of(context).select_all,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  value: isAllSelected,
                  onChanged: toggleSelectAll,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(height: 1),
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
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        onSelectionChanged(tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).apply,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
