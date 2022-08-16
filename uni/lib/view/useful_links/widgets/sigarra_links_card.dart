import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/useful_links/widgets/link_button.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class SigarraLinksCard extends GenericExpansionCard {
  const SigarraLinksCard({Key? key}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: const [
      LinkButton(
          title: 'Notícias',
          link: 'https://sigarra.up.pt/feup/pt/noticias_geral.lista_noticias'),
      LinkButton(
          title: 'Erasmus',
          link:
              'https://sigarra.up.pt/feup/pt/web_base.gera_pagina?P_pagina=257769'),
      LinkButton(
          title: 'Inscrição Geral',
          link: 'https://sigarra.up.pt/feup/pt/ins_geral.inscricao'),
      LinkButton(
          title: 'Inscrição de Turmas',
          link: 'https://sigarra.up.pt/feup/pt/it_geral.ver_insc'),
      LinkButton(
          title: 'Inscrição para Melhoria',
          link:
              'https://sigarra.up.pt/feup/pt/inqueritos_geral.inqueritos_list'),
      LinkButton(
          title: 'Calendário Escolar',
          link:
              'https://sigarra.up.pt/feup/pt/web_base.gera_pagina?p_pagina=p%c3%a1gina%20est%c3%a1tica%20gen%c3%a9rica%20106')
    ]);
  }

  @override
  String getTitle() => 'Links Sigarra';
}
