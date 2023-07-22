import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_row.dart';

class CourseUnitClassesView extends StatelessWidget {
  final List<CourseUnitClass> classes;

  const CourseUnitClassesView(this.classes, {super.key});

  @override
  Widget build(BuildContext context) {
    final Session session = context.read<SessionProvider>().session;
    final List<CourseUnitInfoCard> cards = [];
    for (CourseUnitClass courseUnitClass in classes) {
      final bool isMyClass = courseUnitClass.students
          .where((student) =>
              student.number ==
              (int.tryParse(session.username.replaceAll(RegExp(r"\D"), "")) ??
                  0))
          .isNotEmpty;
      cards.add(CourseUnitInfoCard(
          isMyClass
              ? '${courseUnitClass.className} *'
              : courseUnitClass.className,
          Column(
            children: courseUnitClass.students
                .map((student) => CourseUnitStudentRow(student, session))
                .toList(),
          )));
    }

    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(children: cards));
  }
}
