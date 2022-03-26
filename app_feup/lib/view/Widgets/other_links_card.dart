import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/link_button.dart';
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
      LinkButton(title: 'Impressão', link: 'https://webprint.up.pt/wprint/')
    ]);
  }

  @override
  String getTitle() => 'Outros Links';

  @override
  onClick(BuildContext context) {}
}
