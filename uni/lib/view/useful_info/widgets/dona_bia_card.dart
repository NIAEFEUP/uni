import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/useful_info/widgets/text_components.dart';

class DonaBiaCard extends GenericExpansionCard {
  const DonaBiaCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1(
          S.of(context).nav_title(DrawerItem.navSchedule.title),
          context,
          initial: true,
        ),
        h2(S.of(context).dona_bia_building, context),
        infoText('8:30h - 12:00h | 13:30h - 19:00h', context),
        h1(S.of(context).telephone, context),
        infoText('+351 225 081 416', context, link: 'tel:225 081 416'),
        h1('Email', context),
        infoText(
          'papelaria.fe.up@gmail.com',
          context,
          last: true,
          link: 'mailto:papelaria.fe.up@gmail.com',
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).dona_bia;
}
