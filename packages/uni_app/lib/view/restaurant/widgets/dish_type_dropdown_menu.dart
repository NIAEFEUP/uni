import 'package:flutter/material.dart';

class DishTypeDropdownMenu extends StatelessWidget {
  const DishTypeDropdownMenu(
      {super.key,
      required this.items,
      required this.selectedValue,
      required this.onChange,});

  final List<Map<String, dynamic>> items;
  final int? selectedValue;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 245, 243, 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: DropdownButton<int>(
          underline: const SizedBox(),
          isDense: true,
          iconEnabledColor: const Color.fromRGBO(127, 127, 127, 1),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: const Color.fromRGBO(255, 245, 243, 1),
          value: selectedValue,
          onChanged: onChange,
          items: items.map<DropdownMenuItem<int>>((item) {
            return DropdownMenuItem<int>(
              value: item['value'] as int,
              child: Text(
                item['label'] as String,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color.fromRGBO(127, 127, 127, 1),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
