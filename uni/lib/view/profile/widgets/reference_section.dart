import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/view/common_widgets/toast_message.dart';


class ReferenceSection extends StatelessWidget {
  final Reference reference;

  const ReferenceSection({Key? key, required this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleText(title: reference.description),
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
  final Color? color;

  const InfoText({Key? key, required this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 0.9,
      style: Theme.of(context).textTheme.subtitle2?.copyWith(
        color: color
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
        overflow: TextOverflow.fade,
        softWrap: false,
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
    final Color helperTextColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xff505050) : const Color(0xffafafaf);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InfoText(text: infoName, color: helperTextColor),
          const Spacer(),
          InfoText(text: "${isMoney ? _getMoneyAmount() : info}  "),
          InkWell(
            splashColor: Theme.of(context).highlightColor,
            child: const Icon(Icons.content_copy, size: 16),
            onTap: () {
              Clipboard.setData(ClipboardData(text: info));
              ToastMessage.success(context, "Texto copiado!");
            },
          ),
        ],
      ),
    );
  }

  String _getMoneyAmount()
      => NumberFormat.simpleCurrency(locale: 'eu').format(double.parse(info));
}