import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';

class CourseUnitCard extends GenericCard {
  static const maxTitleLength = 60;
  final CourseUnit courseUnit;

  CourseUnitCard(this.courseUnit, {Key? key})
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
            Text("${courseUnit.ects.toString().replaceAll('.0', '')} ECTS"),
            const Spacer(),
            Text(courseUnit.grade ?? '-')
          ],
        ));
  }

  @override
  String getTitle() {
    return courseUnit.name.length > maxTitleLength
        ? '${courseUnit.name.split(' ').sublist(0, 5).join(' ')}...'
        : courseUnit.name;
  }

  @override
  onClick(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourseUnitDetailPageView(courseUnit)));
  }

  @override
  void onRefresh(BuildContext context) {}
}
