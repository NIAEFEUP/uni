import 'package:flutter/material.dart';

class CalendarItemCard extends StatelessWidget {
  const CalendarItemCard({
    super.key,
    required this.eventName,
    this.isToday = false,
    this.onTap,
    this.width,
  });

  final String eventName;
  final bool isToday;
  final void Function()? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: ShapeDecoration(
          gradient: isToday
              ? RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.onTertiary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  center: Alignment.topLeft,
                  radius: 2,
                  stops: [0, 1],
                )
              : null,
          color: isToday ? null : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
              blurRadius: 2,
            ),
          ],
        ),
        child: Text(
          eventName,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isToday
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
    );
  }
}
