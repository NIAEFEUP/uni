import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generic_card.dart';

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
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child:InkWell(
                    child: Text('Impressão',
                      style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(decoration: TextDecoration.underline)
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