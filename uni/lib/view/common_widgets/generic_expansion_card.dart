import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

/// Card with an expandable child
abstract class GenericExpansionCard extends StatelessWidget {
  const GenericExpansionCard({
    super.key,
    this.smallTitle = false,
    this.cardMargin,
  });
  final bool smallTitle;
  final EdgeInsetsGeometry? cardMargin;

  TextStyle? getTitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall?.apply(
            color: Theme.of(context).primaryColor,
          );

  String getTitle(BuildContext context);

  Widget buildCardContent(BuildContext context);

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
        title: Text(
          getTitle(context),
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.apply(color: Theme.of(context).primaryColor),
        ),
        elevation: 0,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: buildCardContent(context),
          ),
        ],
      ),
    );
  }
}
