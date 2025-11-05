import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/theme.dart';

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
                    style: Theme.of(context).titleMedium,
                  ),
                  value: isAllSelected,
                  onChanged: toggleSelectAll,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...widget.items.map((keyLabel) {
                  return CheckboxListTile(
                    dense: true,
                    title: Text(
                      S.of(context).dish_type(keyLabel),
                      style: Theme.of(context).bodyMedium,
                    ),
                    value: dialogSelected.contains(keyLabel),
                    onChanged: (isChecked) => toggleDish(keyLabel, isChecked),
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
                          tempSelected = dialogSelected;
                        });
                        widget.onSelectionChanged(tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).apply,
                        style: const TextStyle(fontSize: 12, color: white),
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
        backgroundColor: Theme.of(context).secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: () => _showFilterDialog(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(S.of(context).dish_types, style: Theme.of(context).bodyMedium),
          const SizedBox(width: 8),
          const UniIcon(UniIcons.caretDownRegular),
        ],
      ),
    );
  }
}
