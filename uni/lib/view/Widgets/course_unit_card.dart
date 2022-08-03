import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/generic_card.dart';

class CourseUnitCard extends GenericCard {
  final String courseName;
  final String grade;
  final int ects;

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
            Text("${ects.toString()} ECTS"),
            const Spacer(),
            Text(grade)
          ],
        ));
  }

  @override
  String getTitle() {
    return courseName;
  }

  @override
  onClick(BuildContext context) {
    return;
  }
}
