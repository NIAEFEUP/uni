import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class DishTypeDropdownMenu extends StatelessWidget {
  const DishTypeDropdownMenu({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChange,
  });

  final List<Map<String, dynamic>> items;
  final int? selectedValue;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: DropdownButton<int>(
          underline: const SizedBox(),
          isDense: true,
          iconEnabledColor: Theme.of(context).shadowColor,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
          value: selectedValue,
          onChanged: onChange,
          items: items.map<DropdownMenuItem<int>>((item) {
            return DropdownMenuItem<int>(
              value: item['value'] as int,
              child: Text(
                S.of(context).dish_type(item['key_label'] as String),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
