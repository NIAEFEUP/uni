import 'package:flutter/material.dart';
import 'package:uni/view/Pages/UsefulLinks/widgets/link_button.dart';
import 'package:uni/view/Common/generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class OtherLinksCard extends GenericCard {
  OtherLinksCard({Key? key}) : super(key: key);

  const OtherLinksCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: const [
      LinkButton(title: 'Impressão', link: 'https://print.up.pt')
    ]);
  }

  @override
  String getTitle() => 'Outros Links';

  @override
  onClick(BuildContext context) {}
}
