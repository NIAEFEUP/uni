import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';

class WelcomeNewStudents extends StatelessWidget {
  const WelcomeNewStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      tooltip: '',
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  S.of(context).welcome_title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  S.of(context).welcome_message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          UniIcon(
            UniIcons.confetti,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
