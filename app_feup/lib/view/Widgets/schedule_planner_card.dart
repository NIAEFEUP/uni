import 'package:flutter/material.dart';

import 'generic_card.dart';

class SchedulePlannerCard extends GenericCard {
  SchedulePlannerCard({this.items, this.onReorder, Key key}) : super(key: key);

  final List<String> items;
  final Function(int oldIndex, int newIndex) onReorder;
  final double _itemHeight = 50.0;
  final double _borderRadius = 10.0;

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            buildPriorityItems(context),
            buildScheduleItems(context),
          ],
        ),
        SizedBox(height: 5.0),
        Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 32,
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.add_circle_outline_rounded),
              onPressed: () {
                // TODO new schedule
              },
            )),
      ],
    );
  }

  Widget buildPriorityItems(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 1.0,
          maxHeight: this._itemHeight * items.length,
          minWidth: 1.0,
          maxWidth: 50.0,
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            for (int index = 0; index < items.length; index += 1)
              buildPriorityItem(index, context)
          ],
        ));
  }

  Widget buildPriorityItem(int index, BuildContext context) {
    return ConstrainedBox(
      key: Key('$index'),
      constraints: BoxConstraints(
        minHeight: this._itemHeight,
        maxHeight: this._itemHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).hintColor, shape: BoxShape.circle),
        child: Align(
          alignment: Alignment.center,
          child: Text((index + 1).toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .apply(fontSizeDelta: -55)),
        ),
      ),
    );
  }

  Widget buildScheduleItems(BuildContext context) {
    return Expanded(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1.0,
              maxHeight: this._itemHeight * items.length,
            ),
            child: ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                for (int index = 0; index < items.length; index += 1)
                  buildScheduleItem(index, context)
              ],
              onReorder: this.onReorder,
            )));
  }

  Widget buildScheduleItem(int index, BuildContext context) {
    return GestureDetector(
        key: Key('$index'),
        onTap: () {
          // TODO edit schedule
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: this._itemHeight,
            maxHeight: this._itemHeight,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(0x1c, 0, 0, 0),
                      blurRadius: 7.0,
                      offset: Offset(0.0, 1.0))
                ],
                color: Theme.of(context).hintColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(this._borderRadius))),
            child: Align(
              alignment: Alignment.center,
              child: Text(items[index],
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
        ));
  }

  @override
  String getTitle() => 'Planeamento de Horário';

  @override
  onClick(BuildContext context) => null;
}
