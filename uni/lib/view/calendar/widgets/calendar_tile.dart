import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  final String text;
  final bool isOpposite;
  const CalendarTile({Key? key, required this.text, this.isOpposite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(text,
          style: !isOpposite
              ? Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500)
              : Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  )),
    );
  }
}
