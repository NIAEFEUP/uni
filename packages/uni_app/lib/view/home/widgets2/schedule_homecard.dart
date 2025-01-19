import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/generic_homecard.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleHomecard extends GenericHomecard {
  const ScheduleHomecard({
    super.key,
    required super.title,
    required this.activeClasses,
  });

  final List<TimelineItem> activeClasses;

  @override
  Widget buildCardContent(BuildContext context) {
    return SizedBox(
      child: CardTimeline(items: activeClasses),
    );
  }

  @override
  void onClick(BuildContext context) => {};
}
