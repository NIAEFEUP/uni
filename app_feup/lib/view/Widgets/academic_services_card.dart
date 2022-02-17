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
    return Column(children: [
      Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 20.0, bottom: 8.0, left: 20.0), // add margin left: 20
                child: Text('Atendimento presencial',
                    //textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 12.0, left: 20.0),
                  child: Text('9:30h - 16:00h',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20.0),
                child: Text('Atendimento telefónico',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('9:30h - 12:00h | 14:00h - 16:00h',
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Telefone',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('+351 22 508 1977',
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('+351 22 508 1405',
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Gestão de Acesso, Ingresso e Certificação',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('acesso.ingresso@fe.up.pt',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('certificacao@fe.up.pt',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Gestão do estudante',
                    //textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('percurso.academico@fe.up.pt',
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Gestão de curso',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 20.0),
                  child: Text('suporte.cursos@fe.up.pt',
                      style: Theme.of(context).textTheme.headline3))
            ]),
          ]),
    ]);
  }

  @override
  String getTitle() => 'Serviços Académicos';

  @override
  onClick(BuildContext context) {}
}
