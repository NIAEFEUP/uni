import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

/// Manages the courses info (course name, atual year, state and year of
/// first enrolment) on the user personal page.
class CourseInfoCard extends GenericCard {
  CourseInfoCard({required this.course, super.key});

  final Course course;

  @override
  Widget buildCardContent(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 8, left: 10),
              child: Text(
                S.of(context).current_year,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 8, right: 10),
              child: getInfoText(
                course.currYear?.toString() ?? S.of(context).unavailable,
                context,
              ),
            )
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 10),
              child: Text(
                S.of(context).college,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, right: 10),
              child: getInfoText(
                course.faculty?.toUpperCase() ?? S.of(context).unavailable,
                context,
              ),
            )
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 10),
              child: Text(
                S.of(context).average,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, right: 10),
              child: getInfoText(
                course.average.toString(),
                context,
              ),
            )
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, left: 10),
              child: Text(
                S.of(context).ects,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8, right: 10),
              child: getInfoText(
                course.performedECTS.toString().replaceFirst('.0', ''),
                context,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) {
    return course.name ?? S.of(context).no_course_units;
  }

  @override
  void onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {}
}
