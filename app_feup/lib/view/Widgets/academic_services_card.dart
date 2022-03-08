import 'package:flutter/material.dart';
import 'generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class AcademicServicesCard extends GenericCard {
  AcademicServicesCard({Key key}) : super(key: key);

  AcademicServicesCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        Container(
          margin: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Horários',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: 0)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Atendimento presencial',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: -4)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('9:30h - 16:00h',
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Atendimento telefónico',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: -4)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('9:30h - 12:00h | 14:00h - 16:00h',
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 35, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Telefone',
                //textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: 0)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('+351 22 508 1977',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('+351 22 508 1405',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 35, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Departamentos',
                //textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: 0)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Gestão de Acesso, Ingresso e Certificação',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: -4)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('acesso.ingresso@fe.up.pt',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('certificacao@fe.up.pt',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Gestão do Estudante',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: -4)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('percurso.academico@fe.up.pt',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Gestão do curso',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: -4)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('suporte.cursos@fe.up.pt',
                //textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
      ],
    );
  }

  @override
  String getTitle() => 'Serviços Académicos';

  @override
  onClick(BuildContext context) {}
}
