import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/dish_type.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';

class DishTypeCheckboxMenu extends StatefulWidget {
  const DishTypeCheckboxMenu({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  final List<DishType> items;
  final Set<int> selectedValues;
  final void Function(Set<int>) onSelectionChanged;

  @override
  State<DishTypeCheckboxMenu> createState() => _DishTypeCheckboxMenuState();
}

class _DishTypeCheckboxMenuState extends State<DishTypeCheckboxMenu> {
  late Set<int> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = Set<int>.from(widget.selectedValues);
  }

  void toggleSelectAll(bool? isChecked) {
    setState(() {
      if (isChecked ?? false) {
        tempSelected = widget.items.map((item) => item.id).toSet();
      } else {
        tempSelected.clear();
      }
    });
  }

  void toggleDish(int id, bool? isChecked) {
    setState(() {
      if (isChecked ?? false) {
        tempSelected.add(id);
      } else {
        tempSelected.remove(id);
      }
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final allValues = widget.items.map((item) => item.id).toSet();
        final localTempSelected = Set<int>.from(tempSelected);

        return StatefulBuilder(
          builder: (context, setModalState) {
            final isAllSelected = localTempSelected.length == allValues.length;

            void toggleSelectAll(bool? isChecked) {
              setModalState(() {
                if (isChecked ?? false) {
                  localTempSelected.addAll(allValues);
                } else {
                  localTempSelected.clear();
                }
              });
            }

            void toggleDish(int id, bool? isChecked) {
              setModalState(() {
                if (isChecked ?? false) {
                  localTempSelected.add(id);
                } else {
                  localTempSelected.remove(id);
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
                ...widget.items.map((item) {
                  return CheckboxListTile(
                    dense: true,
                    title: Text(
                      S.of(context).dish_type(item.keyLabel),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: localTempSelected.contains(item.id),
                    onChanged: (isChecked) => toggleDish(item.id, isChecked),
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
                        setState(() {
                          tempSelected = localTempSelected;
                        });
                        widget.onSelectionChanged(tempSelected);
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
          const UniIcon(UniIcons.caretDownRegular),
        ],
      ),
    );
  }
}
