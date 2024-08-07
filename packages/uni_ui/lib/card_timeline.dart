import 'package:flutter/material.dart';
import 'package:uni_ui/generic_card.dart';

class CardTimeline extends StatelessWidget {
  const CardTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [Text('10h30'), Text('12h30')],
      ),
      Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  Theme.of(context).primaryColor, // Set the color of the border
              width: 4.0, // Set the width of the border
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
            height: 50,
            width: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).primaryColor))
      ]),
    ]);
  }
}
