import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generic_card.dart';
import 'package:url_launcher/link.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class OtherLinksCard extends GenericCard {
  OtherLinksCard({Key key}) : super(key: key);

  OtherLinksCard.fromEditingInformation(
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
                child: Text('Impressão',
                    //textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        
                        ),
              )
            ]),
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 12.0, left: 20.0),
                  child:InkWell(
                    child: new Text('https://webprint.up.pt/wprint/',
                      style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -2)
                    ),
                    onTap: () => launch('https://webprint.up.pt/wprint/'),
                  )
                      )
            ]),

          ]),
    ]);
  }

  @override
  String getTitle() => 'Outros Links';

  @override
  onClick(BuildContext context) {}
}