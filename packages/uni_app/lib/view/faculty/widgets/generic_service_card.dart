import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';
import 'package:uni_ui/cards/service_card.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({super.key, required this.name, required this.openingHours});

  final String name;
  final List<String> openingHours;

  void onClick(BuildContext context) => {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServiceCard(
            name: name,
            openingHours: openingHours,
        ),
      ],
    );
  }
}
