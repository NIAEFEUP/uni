import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/useful_info/widgets/text_components.dart';

class AcademicServicesCard extends GenericExpansionCard {
  const AcademicServicesCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1('Horário', context, initial: true),
        h2('Atendimento presencial', context),
        infoText('11:00h - 16:00h', context),
        h2('Atendimento telefónico', context),
        infoText('9:30h - 12:00h | 14:00h - 16:00h', context),
        h1('Telefone', context),
        infoText('+351 225 081 977', context,
            link: 'tel:225 081 977', last: true,),
      ],
    );
  }

  @override
  String getTitle() => 'Serviços Académicos';
}
