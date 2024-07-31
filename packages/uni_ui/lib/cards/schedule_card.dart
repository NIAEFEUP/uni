import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCard extends GenericCard {
  const ScheduleCard(
      {super.key,
      required this.name,
      required this.acronym,
      required this.room,
      required this.type,
      required this.badgeColor,
      this.isActive = false,
      this.teacherName,
      this.teacherPhoto});

  final String name;
  final String acronym;
  final String room;
  final String type;
  final BadgeColors badgeColor;
  final bool isActive;
  final String? teacherName;
  final String? teacherPhoto;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      acronym,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8), //TODO: Create a custom Gap()?
                    Badge(
                      label: Text(type),
                      backgroundColor: badgeColor,
                      textColor: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), //TODO: Create a custom Gap()?
          Column(
            children: [
              PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
              Text(
                room,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}
