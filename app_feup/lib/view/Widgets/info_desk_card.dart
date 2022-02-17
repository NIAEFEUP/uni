import 'package:flutter/material.dart';
import 'generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class InfoDeskCard extends GenericCard {
  InfoDeskCard({Key key}) : super(key: key);

  InfoDeskCard.fromEditingInformation(
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
                child: Text('Atendimento presencial e telefónico',
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
                  child: Text('9:30h - 13:00h | 14:00h - 17:30h',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Telefone',
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
                  child: Text('+351 22 041 3508',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Email ',
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
                  child: Text('candidato@fe.up.pt',
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3))
            ]),
          ]),
    ]);
  }

  @override
  String getTitle() => 'Info Desk';

  @override
  onClick(BuildContext context) {}
}
