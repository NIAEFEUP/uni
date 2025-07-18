import 'package:flutter/material.dart';
import 'package:uni_ui/courses/course_card.dart';
import 'package:uni_ui/courses/course_info.dart';

class CourseSelection extends StatelessWidget {
  final List<CourseInfo> courseInfos;
  final void Function(int) onSelected;
  final int selected;
  final String nowText;

  CourseSelection({
    required this.courseInfos,
    required this.onSelected,
    required this.selected,
    required this.nowText,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView + Row is used instead of ListView to prevent row
    // from expanding vertically
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            courseInfos.indexed.map<CourseCard>((entry) {
              final index = entry.$1;
              final courseInfos = entry.$2;

              return CourseCard(
                courseInfo: courseInfos,
                selected: index == selected,
                onTap: () => {onSelected(index)},
                nowText: nowText,
              );
            }).toList(),
      ),
    );
  }
}
