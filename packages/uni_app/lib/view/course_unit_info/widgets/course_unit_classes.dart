import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_row.dart';

class CourseUnitClassesView extends StatefulWidget {
  const CourseUnitClassesView(this.classes, {super.key});

  final List<CourseUnitClass> classes;

  @override
  _CourseUnitClassesViewState createState() => _CourseUnitClassesViewState();
}

class _CourseUnitClassesViewState extends State<CourseUnitClassesView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    final studentNumber =
        int.tryParse(session.username.replaceAll(RegExp(r'\D'), '')) ?? 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.classes.length,
              itemBuilder: (context, index) {
                final courseUnitClass = widget.classes[index];
                final isMyClass = courseUnitClass.students
                    .any((student) => student.number == studentNumber);
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      isMyClass
                          ? '${courseUnitClass.className} *'
                          : courseUnitClass.className,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
              children: widget.classes[selectedIndex].students
                  .map((student) => CourseUnitStudentRow(student, session))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
