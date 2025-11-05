import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.name,
    required this.acronym,
    required this.room,
    required this.type,
    this.isActive = false,
    this.teacherName,
    this.teacherPhoto,
    this.onTap,
  });

  final String name;
  final String acronym;
  final String room;
  final String type;
  final bool isActive;
  final String? teacherName;
  final Image? teacherPhoto;
  final VoidCallback? onTap;

  static const Map<String, Color> scheduleTypeColors = {
    'T': BadgeColors.t,
    'TP': BadgeColors.tp,
    'P': BadgeColors.p,
    'PL': BadgeColors.pl,
    'OT': BadgeColors.ot,
    'TC': BadgeColors.tc,
  };

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      gradient:
          isActive
              ? RadialGradient(
                colors: [Color(0xFF280709), Color(0xFF511515)],
                center: Alignment.topLeft,
                radius: 1.5,
                stops: [0, 1],
              )
              : null,
      key: key,
      tooltip: '',
      onClick: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isActive) ...[
                      PhosphorIcon(
                        PhosphorIcons.clock(PhosphorIconsStyle.duotone),
                        color: Theme.of(context).secondary,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                    ],
                    Text(
                      acronym,
                      overflow: TextOverflow.ellipsis,
                      style:
                          isActive
                              ? Theme.of(context).titleLarge
                              : Theme.of(context).headlineSmall,
                    ),
                    const SizedBox(width: 8), //TODO: Create a custom Gap()?
                    Badge(
                      label: Text(type),
                      backgroundColor: scheduleTypeColors[type],
                      textColor: Theme.of(context).background,
                    ),
                  ],
                ),
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style:
                      isActive
                          ? Theme.of(context).titleSmall
                          : Theme.of(context).bodySmall,
                ),
                if (isActive && teacherName != null) SizedBox(height: 5),
                if (isActive && teacherName != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: teacherPhoto?.image,
                      ),
                      const SizedBox(width: 8), //TODO: create gap()?
                      SizedBox(
                        width: 140,
                        child: Text(
                          teacherName!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).titleSmall,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            children: [
              PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                color:
                    isActive
                        ? Theme.of(context).secondary
                        : Theme.of(context).primaryVibrant,
                size: 35,
              ),
              Text(
                room,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      isActive
                          ? Theme.of(context).secondary
                          : Theme.of(context).primaryVibrant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
