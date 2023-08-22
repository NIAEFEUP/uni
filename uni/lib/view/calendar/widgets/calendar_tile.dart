import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile({required this.text, super.key, this.isOpposite = false});
  final String text;
  final bool isOpposite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        style: !isOpposite
            ? Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w500)
            : Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
      ),
    );
  }
}
