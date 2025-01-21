import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {required this.title,
      required this.subtitle,
      required this.card,
      this.isActive = false,
      super.key});

  final String title;
  final String subtitle;
  final Widget card;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 50,
        child: Column(
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(subtitle,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
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
            height: 55,
            width: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).primaryColor))
      ]),
      Expanded(child: card)
    ]);
  }
}

class CardTimeline extends StatelessWidget {
  const CardTimeline({required this.items, super.key});

  final List<TimelineItem> items;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}
