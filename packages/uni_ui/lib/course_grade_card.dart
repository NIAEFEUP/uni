import 'package:flutter/material.dart';
import 'package:uni_ui/generic_card.dart';

class CourseGradeCard extends StatelessWidget {
  const CourseGradeCard(
      {required this.courseName,
      required this.ects,
      required this.grade,
      super.key});

  final String courseName;
  final double ects;
  final double grade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GenericCard(
        key: key,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                courseName,
                style: theme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${ects} ECTS",
                    style: theme.textTheme.bodyLarge
                  ),
                  Text("${grade.toInt()}",
                      style: theme.textTheme.bodyLarge)
                ],
              )
            ],
          ),
        ));
  }
}
