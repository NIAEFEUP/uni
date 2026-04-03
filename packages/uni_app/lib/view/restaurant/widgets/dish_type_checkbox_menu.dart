import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';

class DishTypeCheckboxMenu extends StatefulWidget {
  const DishTypeCheckboxMenu({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  final List<String> items;
  final Set<String> selectedValues;
  final void Function(Set<String>) onSelectionChanged;

  @override
  State<DishTypeCheckboxMenu> createState() => _DishTypeCheckboxMenuState();
}

class _DishTypeCheckboxMenuState extends State<DishTypeCheckboxMenu> {
  late Set<String> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = {...widget.selectedValues};
  }

  void toggleSelectAll() {
    setState(() {
      if (tempSelected.length == widget.items.length) {
        tempSelected.clear();
      } else {
        tempSelected = widget.items.toSet();
      }
    });
    widget.onSelectionChanged(tempSelected);
  }

  void _showFilterDialog(BuildContext context) {
    var dialogSelected = <String>{...tempSelected};

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isAllSelected = dialogSelected.length == widget.items.length;

            void toggleSelectAll(bool? isChecked) {
              setModalState(() {
                if (isChecked!) {
                  dialogSelected = widget.items.toSet();
                } else {
                  dialogSelected.clear();
                }
              });
            }

            void toggleDish(String keyLabel, bool? isChecked) {
              setModalState(() {
                if (isChecked!) {
                  dialogSelected.add(keyLabel);
                } else {
                  dialogSelected.remove(keyLabel);
                }
              });
            }

            return ModalDialog(
              children: [
                CheckboxListTile(
                  title: Text(
                    S.of(context).select_all,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  activeColor: Theme.of(
                    context,
                  ).colorScheme.onSecondaryContainer,
                  checkColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  value: isAllSelected,
                  onChanged: toggleSelectAll,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                const SizedBox(height: 8),
                ...widget.items.map((keyLabel) {
                  final isSelected = dialogSelected.contains(keyLabel);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: CheckboxListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -2),
                      title: Text(
                        S.of(context).dish_type(keyLabel),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      secondary: RestaurantUtils.getIcon(
                        RestaurantUtils.getMealName(keyLabel),
                        color: Theme.of(context).iconTheme.color,
                      ),
                      activeColor: Theme.of(
                        context,
                      ).colorScheme.onSecondaryContainer,
                      checkColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                      value: isSelected,
                      onChanged: (isChecked) => toggleDish(keyLabel, isChecked),
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempSelected = dialogSelected;
                        });
                        widget.onSelectionChanged(tempSelected);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      child: Text(
                        S.of(context).apply,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            )
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

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showFilterDialog(context),
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).dish_types,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          UniIcon(
            UniIcons.caretDownRegular,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }
}
