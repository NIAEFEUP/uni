import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

/// Card with a expansible child
abstract class GenericExpansionCard extends StatefulWidget {
  const GenericExpansionCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GenericExpansionCardState();
  }

  TextStyle? getTitleStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineSmall
      ?.apply(color: Theme.of(context).primaryColor);

  String getTitle();
  Widget buildCardContent(BuildContext context);
}

class GenericExpansionCardState extends State<GenericExpansionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ExpansionTileCard(
          expandedTextColor: Theme.of(context).primaryColor,
          heightFactorCurve: Curves.ease,
          turnsCurve: Curves.easeOutBack,
          expandedColor: (Theme.of(context).brightness == Brightness.light)
              ? const Color.fromARGB(0xf, 0, 0, 0)
              : const Color.fromARGB(255, 43, 43, 43),
          title: Text(widget.getTitle(), style: widget.getTitleStyle(context)),
          elevation: 0,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: widget.buildCardContent(context),
            )
          ],
        ));
  }
}
