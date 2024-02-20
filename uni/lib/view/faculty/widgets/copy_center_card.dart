import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/text_components.dart';

class CopyCenterCard extends GenericExpansionCard {
  const CopyCenterCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1(
          S.of(context).nav_title(NavigationItem.navSchedule.route),
          context,
          initial: true,
        ),
        h2(S.of(context).copy_center_building, context),
        infoText('9:00h - 11:30h | 12:30h - 18:00h', context),
        h1(S.of(context).telephone, context),
        h2('FEUP ', context),
        infoText('+351 220 994 122', context, link: 'tel:220 994 122'),
        h2('AEFEUP ', context),
        infoText('+351 220 994 132', context, link: 'tel:220 994 132'),
        h1('Email', context),
        infoText(
          'editorial@aefeup.pt',
          context,
          link: 'mailto:editorial@aefeup.pt',
          last: true,
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).copy_center;
}
