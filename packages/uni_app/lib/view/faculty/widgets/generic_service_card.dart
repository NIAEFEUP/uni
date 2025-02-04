import 'package:flutter/material.dart';
import 'package:uni_ui/cards/service_card.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.name,
    required this.openingHours,
  });

  final String name;
  final List<String> openingHours;

  void onClick(BuildContext context) => {};

  @override
  Widget build(BuildContext context) {
    return ServiceCard(
      name: name,
      openingHours: openingHours,
    );
  }
}
