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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    S.of(context).transactions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),

                ...widget.items.map((keyLabel) {
                  final isSelected = dialogSelected == keyLabel;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -2),
                      selected: isSelected,
                      selectedTileColor: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(20),
                      title: Text(
                        _getFilterLabel(context, keyLabel),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        setModalState(() {
                          dialogSelected = keyLabel;
                        });
                      },
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
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          currentSelected = dialogSelected;
                        });
                        widget.onSelectionChanged(currentSelected);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).apply,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: const StadiumBorder(),
      ),
      onPressed: () => _showFilterDialog(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFilterLabel(context, currentSelected),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }
}
