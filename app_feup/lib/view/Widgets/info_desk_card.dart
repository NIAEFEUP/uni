import 'package:flutter/material.dart';
import 'generic_card.dart';

Container h1(String text, BuildContext context, {bool initial = false}) {
  final double marginTop = initial ? 15.0 : 30.0;
  return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: 0)),
      ));
}

Container h2(String text, BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4)),
      ));
}

Container infoText(String text, BuildContext context, {bool last = false}) {
  final double marginBottom = last ? 8.0 : 0.0;
  return Container(
    margin: EdgeInsets.only(top: 8, bottom: marginBottom, left: 20.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: Theme.of(context).textTheme.headline3),
    ),
  );
}

class InfoDeskCard extends GenericCard {
  InfoDeskCard({Key key}) : super(key: key);

  InfoDeskCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        h1('Horário', context, initial: true),
        h2('Atendimento presencial e telefónico', context),
        infoText('9:30h - 13:00h | 14:00h - 17:30h', context),
        h1('Telefone', context),
        infoText('+351 225 081 400', context),
        h1('Email', context),
        infoText('infodesk@fe.up.pt', context, last: true)
      ],
    );
  }

  @override
  String getTitle() => 'Infodesk';

  @override
  onClick(BuildContext context) {}
}
