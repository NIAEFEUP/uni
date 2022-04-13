import 'package:flutter/material.dart';
import 'generic_card.dart';
import '../Pages/useful_contacts_card_page_view.dart';

class InfoDeskCard extends GenericCard {
  InfoDeskCard({Key key}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1('Horário', context, initial: true),
        h2('Atendimento presencial e telefónico', context),
        infoText('9:30h - 13:00h | 14:00h - 17:30h', context),
        h1('Telefone', context),
        infoText('+351 225 081 400', context),
        h1('Email', context),
        infoText('infodesk@fe.up.pt', context, last: true)
      ],
    );
  }

  @override
  String getTitle() => 'Infodesk';

  @override
  onClick(BuildContext context) {}
}
