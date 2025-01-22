import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_row.dart';
import 'package:uni_ui/theme.dart';

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
    final sessionProvider = context.read<SessionProvider>();
    final studentNumber = int.tryParse(
          sessionProvider.state!.username.replaceAll(RegExp(r'\D'), ''),
        ) ??
        0;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClassSelector(studentNumber),
          _buildStudentList(sessionProvider),
        ],
      ),
    );
  }

  Widget _buildClassSelector(int studentNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 55, // Adjust height to fit your design.
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.classes.length,
          itemBuilder: (context, index) {
            final courseUnitClass = widget.classes[index];
            final isMyClass = courseUnitClass.students
                .any((student) => student.number == studentNumber);
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () => setState(() {
                selectedIndex = index;
              }),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? lightTheme.colorScheme.primary
                      : lightTheme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  isMyClass
                      ? '${courseUnitClass.className} *'
                      : courseUnitClass.className,
                  style: isSelected
                      ? lightTheme.textTheme.labelMedium?.copyWith(
                          color: lightTheme.colorScheme.onPrimary,
                        )
                      : lightTheme.textTheme.labelMedium,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentList(SessionProvider session) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8), // Adjust padding as needed
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: widget.classes[selectedIndex].students.length,
        itemBuilder: (context, index) {
          final student = widget.classes[selectedIndex].students[index];
          return CourseUnitStudentRow(student, session.state!);
        },
      ),
    );
  }

}
