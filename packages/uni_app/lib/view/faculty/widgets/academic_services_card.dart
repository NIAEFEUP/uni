import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';
import 'package:uni_ui/cards/service_card.dart';

class AcademicServicesCard extends GenericCard {
  AcademicServicesCard({super.key});

  @override
  void onClick(BuildContext context) => {};

  @override
  void onRefresh(BuildContext context) => {};

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
        ServiceCard(
            name: S.of(context).nav_title(NavigationItem.navSchedule.route),
            openingHours: const [
              '11:00h - 16:00h',
            ],
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).academic_services;
}
