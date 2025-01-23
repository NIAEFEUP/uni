import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_tile.dart';
import 'package:uni_ui/theme.dart';

class CourseUnitClassesView extends StatefulWidget {
  const CourseUnitClassesView(this.classes, {super.key});

  final List<CourseUnitClass> classes;

  @override
  _CourseUnitClassesViewState createState() => _CourseUnitClassesViewState();
}

class _CourseUnitClassesViewState extends State<CourseUnitClassesView> {
  static const double _itemWidth = 140;
  static const Duration _scrollDuration = Duration(milliseconds: 300);

  late int selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final sessionProvider = context.read<SessionProvider>();
    final studentNumber = int.tryParse(
          sessionProvider.state!.username.replaceAll(RegExp(r'\D'), ''),
        ) ??
        0;

    selectedIndex = widget.classes.indexWhere(
      (courseClass) => courseClass.students.any(
        (student) => student.number == studentNumber,
      ),
    );

    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedClass();
    });
  }

  void _scrollToSelectedClass() {
    final screenWidth = MediaQuery.of(context).size.width;
    final offset =
        (_itemWidth * selectedIndex) - (screenWidth - _itemWidth) / 2;

    _scrollController.animateTo(
      offset < 0 ? 0 : offset,
      duration: _scrollDuration,
      curve: Curves.easeInOut,
    );
  }

  void _handleClassTap(int index) {
    setState(() => selectedIndex = index);
    _scrollToSelectedClass();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        height: 55,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.classes.length,
          itemBuilder: (context, index) {
            final courseUnitClass = widget.classes[index];
            final isMyClass = courseUnitClass.students
                .any((student) => student.number == studentNumber);
            final isSelected = index == selectedIndex;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _itemWidth,
                maxWidth: _itemWidth,
              ),
              child: GestureDetector(
                onTap: () => _handleClassTap(index),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
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
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentList(SessionProvider session) {
    final currentClass = widget.classes[selectedIndex];
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: GridView.builder(
        key: ValueKey(currentClass.className),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 5,
          childAspectRatio: 0.60,
        ),
        itemCount: currentClass.students.length,
        itemBuilder: (context, index) {
          final student = currentClass.students[index];
          return CourseUnitStudentTile(
            student,
            session.state!,
            key: ValueKey('${currentClass.className}_${student.number}'),
          );
        },
      ),
    );
  }
}
