import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/theme.dart';

class ModalServiceInfo extends StatelessWidget {
  const ModalServiceInfo({required this.name, required this.durations});

  final String name;
  final List<String> durations;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 25.0, color: Theme.of(context).primaryColor),
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
                  children: durations.map((duration) {
                    return Text(duration,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).secondaryHeaderColor));
                  }).toList(),
                )
              ],
            ),
          ],
        ));
  }
}
