import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';

class CourseGradeCard extends StatelessWidget {
  const CourseGradeCard({
    required this.courseName,
    required this.ects,
    required this.grade,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final String courseName;
  final double ects;
  final String? grade;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
      blurRadius: 2,
      key: key,
      tooltip: tooltip,
      onClick: onTap,
      margin: EdgeInsets.zero,
      color: grade == ''
          ? null
          : ((double.tryParse(grade!) ?? 0) >= 10
                ? null
                : Theme.of(context).disabledColor),
      child: SizedBox(
        height: 75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              courseName,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ects == ects.toInt() ? ects.toInt() : ects} ECTS',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${grade ?? ""}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
