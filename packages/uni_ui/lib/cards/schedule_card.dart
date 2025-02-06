import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key,
      required this.name,
      required this.acronym,
      required this.room,
      required this.type,
      // required this.badgeColor,
      this.isActive = false,
      this.teacherName,
      this.teacherPhoto});

  final String name;
  final String acronym;
  final String room;
  final String type;
  // final BadgeColors badgeColor;
  final bool isActive;
  final String? teacherName;
  final String? teacherPhoto;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      gradient: isActive
          ? RadialGradient(
              colors: [
                Color(0xFF280709),
                Color(0xFF511515),
              ],
              center: Alignment.topLeft,
              radius: 1.5,
              stops: [0, 1])
          : null,
      key: key,
      tooltip: '',
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
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                    ],
                    Text(
                      acronym,
                      overflow: TextOverflow.ellipsis,
                      style: isActive
                          ? Theme.of(context).textTheme.titleLarge
                          : Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 8), //TODO: Create a custom Gap()?
                    Badge(
                      label: Text(type),
                      backgroundColor: BadgeColors.tp,
                      textColor: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: isActive
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 5),
                if (isActive)
                  Row(children: [
                    CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                          teacherPhoto ??
                              'assets/images/profile_placeholder.png', // to change
                        )),
                    const SizedBox(width: 8), //TODO: create gap()?
                    Text(teacherName ?? 'Teacher X',
                        style: Theme.of(context).textTheme.titleSmall),
                  ])
              ],
            ),
          ),
          Column(
            children: [
              PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).iconTheme.color,
                size: 35,
              ),
              Text(room,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary)),
            ],
          )
        ],
      ),
    );
  }
}
