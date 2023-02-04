import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/useful_info/widgets/text_components.dart';

class ReferenceCard extends GenericExpansionCard {
  final Reference reference;

  const ReferenceCard({Key? key, required this.reference}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Container>[
        infoText("Data limite: ${_getLimitDate()}", context),
        infoText("Entidade: ${reference.entity}", context),
        infoText("Referência: ${reference.reference}", context),
        infoText("Montante: ${_getAmount()}", context),
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

  String _getLimitDate()
      => DateFormat("dd-MM-yyyy").format(reference.limitDate);

  String _getAmount()
      => NumberFormat.simpleCurrency(locale: 'eu').format(reference.amount);
}