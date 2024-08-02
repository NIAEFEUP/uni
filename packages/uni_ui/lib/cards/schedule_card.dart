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
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontWeight,
                          color: isActive
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary),
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
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.titleLarge!.fontWeight,
                      color: isActive
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary),
                ),
                SizedBox(height: 5),
                if (isActive)
                  Row(children: [
                    CircleAvatar(
                        radius: 15,
                        backgroundImage: const AssetImage(
                          'assets/images/profile_placeholder.png', // to change
                        )),
                    const SizedBox(width: 8), //TODO: create gap()?
                    Text(teacherName!,
                        style: TextStyle(
                            color: isActive
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary)),
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
      color: isActive ? Color.fromARGB(255, 40, 7, 9) : null,
    );
  }
}
