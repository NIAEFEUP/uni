import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';

class MultimediaCenterCard extends GenericExpansionCard {
  const MultimediaCenterCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1(
          S.of(context).nav_title(NavigationItem.navSchedule.route),
          context,
          initial: true,
        ),
        h2('${S.of(context).room} B123', context),
        infoText('9:00h - 12:30h | 14:30h - 17:00h', context),
        h1(S.of(context).telephone, context),
        infoText('+351 225 081 466', context, link: 'tel:225 081 466'),
        h1('Email', context),
        infoText(
          'imprimir@fe.up.pt',
          context,
          last: true,
          link: 'mailto:imprimir@fe.up.pt',
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).multimedia_center;
}
