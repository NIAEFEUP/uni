import 'package:flutter/material.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCalendarTile extends StatelessWidget {
  const ScheduleCalendarTile({
    super.key,
    required this.acronym,
    required this.typeClass,
    required this.room,
    required this.timeRange,
    required this.teacherName,
    this.isCurrent = false,
  });

  final String acronym;
  final String typeClass;
  final String room;
  final String timeRange;
  final String teacherName;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final textColor = isCurrent
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onSecondary;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isCurrent
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.secondary,
        gradient: isCurrent ? _getCurrentClassGradient(context) : null,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
            blurRadius: 2,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileHeight = constraints.maxHeight;
          final tileWidth = constraints.maxWidth;

          final horizontalPadding = tileWidth < 40 ? 1.0 : 4.0;
          final verticalPadding = tileHeight < 40 ? 1.0 : 4.0;

          final availableHeight = tileHeight - (verticalPadding * 2);
          final availableWidth = tileWidth - (horizontalPadding * 2);

          final showRoom = availableHeight >= 40 && availableWidth >= 30;
          final showBadge = availableHeight >= 50 && availableWidth >= 40;
          final showTime = availableHeight >= 70 && availableWidth >= 40;
          final showTeacher = availableHeight >= 90 && availableWidth >= 40;

          final showAcronym = availableHeight >= 15 && availableWidth >= 15;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ClipRect(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showAcronym)
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            acronym,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (showBadge) const SizedBox(height: 1),
                          if (showBadge)
                            Badge(
                              label: Text(typeClass),
                              backgroundColor:
                                  ScheduleCard.scheduleTypeColors[typeClass] ??
                                  BadgeColors.t,
                              textColor: Theme.of(context).colorScheme.primary,
                            ),
                          if (showTime)
                            Text(
                              timeRange,
                              style: TextStyle(color: textColor, fontSize: 9),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (showTeacher)
                            Text(
                              teacherName,
                              style: TextStyle(color: textColor, fontSize: 9),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  if (showRoom) _buildLocationRow(room, textColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Gradient _getCurrentClassGradient(BuildContext context) {
    return RadialGradient(
      colors: [
        Theme.of(context).colorScheme.onTertiary,
        Theme.of(context).colorScheme.tertiary,
      ],
      center: Alignment.topLeft,
      radius: 2,
      stops: const [0, 1],
    );
  }

  Widget _buildLocationRow(String roomStr, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        UniIcon(UniIcons.mapPin, color: color, size: 12),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            roomStr,
            style: TextStyle(color: color, fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
