import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.card,
    this.isActive = false,
    this.titleWidth = 50,
    this.titleTextAlign = TextAlign.start,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget card;
  final bool isActive;
  final double titleWidth;
  final TextAlign titleTextAlign;

  @override
  Widget build(BuildContext context) {
    final Color lineColor = Theme.of(context).colorScheme.onSecondary;

    return Stack(
      children: [
        Positioned(
          left: titleWidth + 18.5,
          top: 25,
          bottom: 5,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: lineColor,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: titleWidth,
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: titleTextAlign,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: titleTextAlign,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? lineColor : Colors.transparent,
                border: Border.all(color: lineColor, width: 4.0),
              ),
              child: isActive
                  ? Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(child: card),
          ],
        ),
      ],
    );
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
