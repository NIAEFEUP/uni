import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';

class AcademicServicesCard extends GenericExpansionCard {
  const AcademicServicesCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1(
          S.of(context).nav_title(NavigationItem.navSchedule.route),
          context,
          initial: true,
        ),
        h2(S.of(context).personal_assistance, context),
        infoText('11:00h - 16:00h', context),
        h2(S.of(context).tele_assistance, context),
        infoText('9:30h - 12:00h | 14:00h - 16:00h', context),
        h1(S.of(context).telephone, context),
        infoText(
          '+351 225 081 977',
          context,
          link: 'tel:225 081 977',
          last: true,
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).academic_services;
}
