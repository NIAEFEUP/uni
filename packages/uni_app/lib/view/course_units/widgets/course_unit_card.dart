import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';

class CourseUnitCard extends GenericCard {
  CourseUnitCard(this.courseUnit, {super.key})
      : super.customStyle(
          margin: const EdgeInsets.only(top: 10),
          hasSmallTitle: true,
          onDelete: () {},
          editingMode: false,
        );
  static const maxTitleLength = 60;
  final CourseUnit courseUnit;

  @override
  Widget buildCardContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          if (courseUnit.ects != null)
            Text("${courseUnit.ects.toString().replaceAll('.0', '')} ECTS"),
          const Spacer(),
          Text(courseUnit.grade ?? '-'),
        ],
      ),
    );
  }

  @override
  String getTitle(BuildContext context) {
    return courseUnit.name.length > maxTitleLength
        ? '${courseUnit.name.split(' ').sublist(0, 5).join(' ')}...'
        : courseUnit.name;
  }

  @override
  void onClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<CourseUnitDetailPageView>(
        builder: (context) => CourseUnitDetailPageView(courseUnit),
      ),
    );
  }

  @override
  void onRefresh(BuildContext context) {}
}
