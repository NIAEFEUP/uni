import 'package:flutter/material.dart';
import 'generic_card.dart';
import 'package:uni/view/Widgets/info_desk_card.dart';

class CopyCenterCard extends GenericCard {
  CopyCenterCard({Key key}) : super(key: key);

  CopyCenterCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1('Horário', context, initial: true),
        h2('Piso -1 do edifício B | Edifício da AEFEUP', context),
        infoText('9:00h - 11:30h | 12:30h - 18:00h', context),
        h1('Telefone', context),
        h2('FEUP ', context),
        infoText('+351 220 994 122', context, link: 'tel:220 994 122'),
        h2('AEFEUP ', context),
        infoText('+351 220 994 132', context,
            link: 'tel:220 994 132', last: true),
      ],
    );
  }

  @override
  String getTitle() => 'Centro de Cópias';

  @override
  onClick(BuildContext context) {}
}
