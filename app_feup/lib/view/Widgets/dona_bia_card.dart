import 'package:flutter/material.dart';
import 'generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class DonaBiaCard extends GenericCard {
  DonaBiaCard({Key key}) : super(key: key);

  DonaBiaCard.fromEditingInformation(
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
            child: Text('Horário',
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
            child: Text('Piso -1 do edifício B (B -142)',
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
            child: Text('8:30h - 12:00h | 13:30h - 19:00h',
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 0.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Telefone',
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
            child: Text('+351 225 081 416',
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Email',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(fontSizeDelta: 0)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 20.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('papelaria.fe.up@gmail.com',
                  style: Theme.of(context).textTheme.headline3)),
        ),
      ],
    );
  }

  @override
  String getTitle() => 'Papelaria D. Bia';

  @override
  onClick(BuildContext context) {}
}
