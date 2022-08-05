import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/generic_card.dart';

class CourseUnitCard extends GenericCard {
  static const maxTitleLength = 60;
  final String courseName;
  final String grade;
  final num ects;

  CourseUnitCard(this.courseName, this.grade, this.ects, {Key? key})
      : super.customStyle(
            key: key,
            margin: const EdgeInsets.only(top: 10),
            smallTitle: true,
            onDelete: () => null,
            editingMode: false);

  @override
  Widget buildCardContent(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Text("${ects.toString().replaceAll('.0', '')} ECTS"),
            const Spacer(),
            Text(grade)
          ],
        ));
  }

  @override
  String getTitle() {
    return courseName.length > maxTitleLength
        ? '${courseName.split(' ').sublist(0, 5).join(' ')}...'
        : courseName;
  }

  @override
  onClick(BuildContext context) {
    return;
  }
}
