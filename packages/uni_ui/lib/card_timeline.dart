import 'package:flutter/material.dart';
import 'package:uni_ui/generic_card.dart';

class CardTimeline extends StatelessWidget {
  const CardTimeline(
      {required this.startTime,
      required this.endTime,
      required this.card,
      this.isActive = false,
      super.key});

  final String startTime;
  final String endTime;
  final GenericCard card;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 50,
        child: Column(
          children: [
            Text(startTime,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(endTime, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
      Column(children: [
        Container(
            margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Theme.of(context).primaryColor : Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 4.0,
              ),
            ),
            child: isActive
                ? Center(
                    child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        )))
                : null),
        Container(
            margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
            height: 50,
            width: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).primaryColor))
      ]),
      Expanded(child: card)
    ]);
  }
}
