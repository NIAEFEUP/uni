import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

abstract class GenericExpansionCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GenericExpansionCardState();
  }

  String getTitle();
  Widget buildCardContent(BuildContext context);
}

class GenericExpansionCardState extends State<GenericExpansionCard> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ExpansionTileCard(
          baseColor: Color.fromARGB(0, 0, 0, 0),
          expandedColor: Theme.of(context).hintColor,
          key: cardA,
          title: Text(widget.getTitle(),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .apply(color: Theme.of(context).primaryColor)),
          elevation: 0,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: this.padding,
                right: this.padding,
                bottom: this.padding,
              ),
              child: widget.buildCardContent(context),
            )
          ],
        ));
  }
}
