import 'package:flutter/material.dart';

/// Display the current date.
///
/// Example: The rectangular section with the text "last update at [time]".
class DateRectangle extends StatelessWidget {

  const DateRectangle({super.key, required this.date});
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
