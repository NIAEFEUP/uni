import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String day;
  final String weekDay;
  final String month;
  final double borderRadius = 8.0;
  TitleCard({
    Key key,
    @required this.day,
    @required this.weekDay,
    @required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: EdgeInsets.only(top: 3, bottom: 3),
      alignment: Alignment.center,
      child: Text(
        '${this.weekDay}, ${this.day} de ${this.month}',
        style: Theme.of(context)
            .textTheme
            .headline6
            .apply(fontSizeDelta: 3, fontWeightDelta: -1),
      ),
    );
  }
}
