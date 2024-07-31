import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/theme.dart';

class ScheduleCard extends GenericCard {
  const ScheduleCard(
      {super.key,
      required this.name,
      required this.acronym,
      required this.type,
      required this.startHour,
      required this.rooms,
      required this.eyeIcon,
      required this.isVisible});

  final String name;
  final String acronym;
  final String type;
  final String startHour;
  final List<String> rooms;
  final bool eyeIcon;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
        key: key,
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      acronym,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Badge(
                      label: Text(type),
                      backgroundColor: BadgeColors.pl,
                      textColor: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
                Text(name),
              ],
            ),
            Column(
              children: [
                PhosphorIcon(
                  PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                  color: Theme.of(context).colorScheme.primary,
                ),
                //Text(room),
              ],
            )
          ],
        ));
  }
}
