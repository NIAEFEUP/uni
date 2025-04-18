import 'package:flutter/material.dart';

class DropdownMenuBugSelect extends StatelessWidget {
  const DropdownMenuBugSelect({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChange,
  });

  final List<DropdownMenuItem<int>> items;
  final int? selectedValue;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bug_report,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              const SizedBox(
                width: 25,
              ),
              DropdownButton<int>(
                underline: const SizedBox(),
                isDense: true,
                iconEnabledColor: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
                value: selectedValue,
                onChanged: onChange,
                items: items,
              ),
            ],
          ),
        ),
      ),
    );
  }

}