import 'package:flutter/material.dart';
import 'generic_card.dart';
import '../Pages/useful_contacts_card_page_view.dart';

class DonaBiaCard extends GenericCard {
  DonaBiaCard({Key key}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1('Horário', context, initial: true),
        h2('Piso -1 do edifício B (B -142)', context),
        infoText('8:30h - 12:00h | 13:30h - 19:00h', context),
        h1('Telefone', context),
        infoText('+351 225 081 416', context),
        h1('Email', context),
        infoText('papelaria.fe.up@gmail.com', context,last: true)
      ],
    );
  }

  @override
  String getTitle() => 'Papelaria D. Beatriz';

  @override
  onClick(BuildContext context) {}
}