import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({required this.name, this.durations});

  final String name;
  final List<String>? durations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          if (durations != null && durations!.isNotEmpty) ...[
            Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UniIcon(
                  UniIcons.clock,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                Padding(padding: EdgeInsets.all(2)),
                Column(
                  children: durations!.map((duration) {
                    return Text(
                      duration,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
