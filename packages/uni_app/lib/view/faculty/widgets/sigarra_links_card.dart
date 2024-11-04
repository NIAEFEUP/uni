import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/faculty/widgets/link_button.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class SigarraLinksCard extends GenericExpansionCard {
  const SigarraLinksCard({super.key});

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
        LinkButton(
          title: S.of(context).news,
          link: 'https://sigarra.up.pt/feup/pt/noticias_geral.lista_noticias',
        ),
        const LinkButton(
          title: 'Erasmus',
          link:
              'https://sigarra.up.pt/feup/pt/web_base.gera_pagina?P_pagina=257769',
        ),
        LinkButton(
          title: S.of(context).geral_registration,
          link: 'https://sigarra.up.pt/feup/pt/ins_geral.inscricao',
        ),
        LinkButton(
          title: S.of(context).class_registration,
          link: 'https://sigarra.up.pt/feup/pt/it_geral.ver_insc',
        ),
        LinkButton(
          title: S.of(context).improvement_registration,
          link:
              'https://sigarra.up.pt/feup/pt/inqueritos_geral.inqueritos_list',
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => 'Links Sigarra';
}
