import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/theme.dart';

class ModalServiceInfo extends StatelessWidget {
  const ModalServiceInfo({
    required this.name,
    required this.morningDuration,
    required this.afternoonDuration,
  });

  final String name;
  final String morningDuration;
  final String afternoonDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style:
              TextStyle(fontSize: 25.0, color: Theme.of(context).primaryColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
              PhosphorIcons.clock(PhosphorIconsStyle.duotone),
              color: darkGray,
              duotoneSecondaryColor: normalGray,
            ),
            Column(
              children: [
                Text(morningDuration,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor)),
                Text(afternoonDuration,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor)),
              ],
            )
          ],
        )
      ],
    );
  }
}
