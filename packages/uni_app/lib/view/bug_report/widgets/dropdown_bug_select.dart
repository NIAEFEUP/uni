import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uni_ui/common/generic_squircle.dart';
import 'package:uni_ui/theme.dart';

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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: GenericSquircle(
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.secondary),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bug_report,
                  color: theme.primaryVibrant,
                ), // update with uni_ui icon
                const SizedBox(width: 25),
                DropdownButton<int>(
                  underline: const SizedBox(),
                  isDense: true,
                  iconEnabledColor: theme.grayMiddle,
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: theme.secondary,
                  value: selectedValue,
                  onChanged: onChange,
                  items: items,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
