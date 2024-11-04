import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class ReferenceSection extends StatelessWidget {
  const ReferenceSection({required this.reference, super.key});
  final Reference reference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleText(title: reference.description),
        InfoCopyRow(
          infoName: 'Entidade',
          info: reference.entity.toString(),
          copyMessage: 'Entidade copiada!',
        ),
        InfoCopyRow(
          infoName: 'Referência',
          info: reference.reference.toString(),
          copyMessage: 'Referência copiada!',
        ),
        InfoCopyRow(
          infoName: 'Montante',
          info: reference.amount.toString(),
          copyMessage: 'Montante copiado!',
          isMoney: true,
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({required this.text, this.color, super.key});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaler: const TextScaler.linear(0.9),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
          ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }
}

class InfoCopyRow extends StatelessWidget {
  const InfoCopyRow({
    required this.infoName,
    required this.info,
    required this.copyMessage,
    super.key,
    this.isMoney = false,
  });
  final String infoName;
  final String info;
  final String copyMessage;
  final bool isMoney;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: <Widget>[
          InfoText(text: infoName),
          const Spacer(),
          InfoText(text: '${isMoney ? _getMoneyAmount() : info}  '),
          InkWell(
            splashColor: Theme.of(context).highlightColor,
            child: const Icon(Icons.content_copy, size: 16),
            onTap: () {
              Clipboard.setData(ClipboardData(text: info));
              ToastMessage.success(context, copyMessage);
            },
          ),
        ],
      ),
    );
  }

  String _getMoneyAmount() =>
      NumberFormat.simpleCurrency(locale: 'eu').format(double.parse(info));
}
