import 'package:flutter/material.dart';

/// Display the current date.
///
/// Example: The rectangular section with the text "last update at [date]".
class DateRectangle extends StatelessWidget {
  const DateRectangle({required this.date, super.key});
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(date, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
