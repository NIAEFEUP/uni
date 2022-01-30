import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
          columnWidths: {1: FractionColumnWidth(.4)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Presencial: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                child: Text('9:30h - 16:00h',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              )
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                child: Text('Telefónico: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 30.0),
                child: Text('9:30h - 12:00h | 14:00h - 16:00h',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              )
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Email: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                child: Text('acesso.ingresso@fe.up.pt',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              )
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Telefone: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                child: Text('+351 22 508 1977 / 1405',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              )
            ])
          ]),
    ]);
  }

  @override
  String getTitle() => 'Serviços Académicos';

  @override
  onClick(BuildContext context) {}
}
