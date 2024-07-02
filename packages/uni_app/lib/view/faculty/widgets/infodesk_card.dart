import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';

class InfoDeskCard extends GenericExpansionCard {
  const InfoDeskCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1(
          S.of(context).nav_title(NavigationItem.navSchedule.route),
          context,
          initial: true,
        ),
        h2(S.of(context).tele_personal_assistance, context),
        infoText('9:30h - 13:00h | 14:00h - 17:30h', context),
        h1(S.of(context).telephone, context),
        infoText('+351 225 081 400', context, link: 'tel:225 081 400'),
        h1('Email', context),
        infoText(
          'infodesk@fe.up.pt',
          context,
          last: true,
          link: 'mailto:infodesk@fe.up.pt',
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => 'Infodesk';
}
