import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_row.dart';

class CourseUnitClassesView extends StatelessWidget {
  const CourseUnitClassesView(this.classes, {super.key});

  final List<CourseUnitClass> classes;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    final cards = <CourseUnitInfoCard>[];
    for (final courseUnitClass in classes) {
      final isMyClass = courseUnitClass.students
          .where(
            (student) =>
                student.number ==
                (int.tryParse(
                      session.username.replaceAll(RegExp(r'\D'), ''),
                    ) ??
                    0),
          )
          .isNotEmpty;
      cards.add(
        CourseUnitInfoCard(
          isMyClass
              ? '${courseUnitClass.className} *'
              : courseUnitClass.className,
          Column(
            children: courseUnitClass.students
                .map((student) => CourseUnitStudentRow(student, session))
                .toList(),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView(children: cards),
    );
  }
}
