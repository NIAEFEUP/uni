import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/modal/modal.dart';

class TransactionFilterMenu extends StatefulWidget {
  const TransactionFilterMenu({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelectionChanged,
  });

  final List<String> items;
  final String selectedValue;
  final void Function(String) onSelectionChanged;

  @override
  State<TransactionFilterMenu> createState() => _TransactionFilterMenuState();
}

class _TransactionFilterMenuState extends State<TransactionFilterMenu> {
  late String currentSelected;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.selectedValue;
  }

  @override
  void didUpdateWidget(TransactionFilterMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      currentSelected = widget.selectedValue;
    }
  }

  void _showFilterDialog(BuildContext context) {
    String dialogSelected = currentSelected;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ModalDialog(
              children: [
                Text(
                  S.of(context).transactions,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                ...widget.items.map((keyLabel) {
                  final isSelected = dialogSelected == keyLabel;

                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    selected: isSelected,
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.onSecondary,
                    title: Text(
                      _getFilterLabel(context, keyLabel),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSecondary
                            : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.onSecondary,
                          )
                        : null,
                    onTap: () {
                      setModalState(() {
                        dialogSelected = keyLabel;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  );
                }),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        S.of(context).cancel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentSelected = dialogSelected;
                        });
                        widget.onSelectionChanged(currentSelected);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSecondary,
                      ),
                      child: Text(
                        S.of(context).apply,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
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

  String _getFilterLabel(BuildContext context, String key) {
    switch (key) {
      case 'Pending':
        return S.of(context).pending;
      case 'Tuition Fees':
        return S.of(context).tuition_fees;
      case 'General History':
        return S.of(context).general_history;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => _showFilterDialog(context),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFilterLabel(context, currentSelected),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
