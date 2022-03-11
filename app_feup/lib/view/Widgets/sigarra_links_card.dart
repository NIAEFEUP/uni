import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class SigarraLinksCard extends GenericCard {
  SigarraLinksCard({Key key}) : super(key: key);

  SigarraLinksCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: [
      Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Notícias',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/noticias_geral.lista_noticias'),
                  )
                      )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Erasmus',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/web_base.gera_pagina?P_pagina=257769'),
                  )
                      )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Inscrição Geral',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/ins_geral.inscricao'),
                  )
                      )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Inscrição de Turmas',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/it_geral.ver_insc'),
                  )
                      )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Inscrição para Melhoria',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/inqueritos_geral.inqueritos_list'),
                  )
                      )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Calendário Escolar',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
                    ),
                    onTap: () => launch('https://sigarra.up.pt/feup/pt/web_base.gera_pagina?p_pagina=p%c3%a1gina%20est%c3%a1tica%20gen%c3%a9rica%20106'),
                  )
                      )
            ]),
            
          ]),
    ]);
  }

  @override
  String getTitle() => 'Links Sigarra';

  @override
  onClick(BuildContext context) {}
}