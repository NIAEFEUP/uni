import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';

class CourseGradeCard extends StatelessWidget {
  const CourseGradeCard(
      {required this.courseName,
      required this.ects,
      required this.grade,
      required this.tooltip,
      super.key});

  final String courseName;
  final double ects;
  final double grade;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GenericCard(
        key: key,
        tooltip: tooltip,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                courseName,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${ects} ECTS", style: theme.textTheme.bodySmall),
                  Text("${grade.toInt()}", style: theme.textTheme.bodySmall)
                ],
              )
            ],
          ),
        ));
  }
}
