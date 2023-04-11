import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/reference.dart';

class ReferenceSection extends StatelessWidget {
  final Reference reference;

  const ReferenceSection({Key? key, required this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
              reference.description,
              style: Theme.of(context).textTheme.headline6
                  ?.copyWith(fontSize: 15, color:
                      Theme.of(context).colorScheme.tertiary),
            textAlign: TextAlign.center),
        ),
        InfoCopyRow(infoName: 'Entidade', info: reference.entity.toString()),
        InfoCopyRow(infoName: 'Referência', info: reference.reference.toString()),
        InfoCopyRow(infoName: 'Montante', info: reference.amount.toString(),
            isMoney: true),
      ]
    );
  }
}

class InfoText extends StatelessWidget {
  final String text;
  final bool lighted;

  const InfoText({Key? key, required this.text, this.lighted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 0.9,
        style: Theme.of(context).textTheme.subtitle2?.copyWith(
          color: lighted ? const Color(0xff505050) : Colors.black
        )
      ),
    );
  }
}

class InfoCopyRow extends StatelessWidget {
  final String infoName;
  final String info;
  final bool isMoney;

  const InfoCopyRow({Key? key, required this.infoName, required this.info,
      this.isMoney = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, top: 2.0, bottom: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InfoText(text: infoName, lighted: true),
            const Spacer(),
            InfoText(text: "${isMoney ? _getMoneyAmount() : info}  "),
            InkWell(
              splashColor: Theme.of(context).highlightColor,
              child: const Icon(Icons.content_copy, size: 16),
              onTap: () => Clipboard.setData(ClipboardData(text: info)),
            ),
          ],
        ),
      ),
    );
  }

  String _getMoneyAmount()
      => NumberFormat.simpleCurrency(locale: 'eu').format(double.parse(info));
}