import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';

class ReferenceCard extends GenericExpansionCard {
  final Reference reference;

  const ReferenceCard({Key? key, required this.reference}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Widget>[
        InfoCopyRow(infoName: 'Entidade', info: reference.entity.toString()),
        InfoCopyRow(infoName: 'Referência', info: reference.reference.toString()),
        InfoCopyRow(infoName: 'Montante', info: _getAmount()),
      ]
    );
  }

  @override
  String getTitle() => reference.description;

  @override
  TextStyle? getTitleStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyText1
      ?.apply(color: Theme.of(context).primaryColor);

  String _getAmount()
      => NumberFormat.simpleCurrency(locale: 'eu').format(reference.amount);
}

class InfoText extends StatelessWidget {
  final String text;

  const InfoText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, top: 4.0, bottom: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1
      ),
    );
  }
}

class InfoCopyRow extends StatelessWidget {
  final String infoName;
  final String info;

  const InfoCopyRow({Key? key, required this.infoName, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InfoText(text: "$infoName: $info"),
          InkWell(
            splashColor: Theme.of(context).highlightColor,
            child: const Icon(Icons.content_copy, size: 16),
            onTap: () => Clipboard.setData(ClipboardData(text: info)),
          )
        ]
      )
    );
  }
}