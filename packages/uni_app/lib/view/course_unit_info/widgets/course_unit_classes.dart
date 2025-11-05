import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/student_number_getter.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_tile.dart';

class CourseUnitClassesView extends ConsumerStatefulWidget {
  const CourseUnitClassesView(this.classes, {super.key});

  final List<CourseUnitClass> classes;

  @override
  ConsumerState<CourseUnitClassesView> createState() =>
      _CourseUnitClassesViewState();
}

class _CourseUnitClassesViewState extends ConsumerState<CourseUnitClassesView> {
  static const double _itemWidth = 140;
  static const _scrollDuration = Duration(milliseconds: 300);

  final _scrollController = ScrollController();

  int? selectedIndex;
  late int studentNumber;

  void _scrollToSelectedClass() {
    final screenWidth = MediaQuery.of(context).size.width;
    final offset =
        (_itemWidth * selectedIndex!) - (screenWidth - _itemWidth) / 2;

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
    final sessionAsync = ref.read(sessionProvider);

    return sessionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (session) {
        final studentNumber = getStudentNumber(session!);

        if (selectedIndex == null) {
          selectedIndex = widget.classes.indexWhere(
            (courseClass) => courseClass.students.any(
              (student) => student.number == studentNumber,
            ),
          );

          if (selectedIndex == -1) {
            selectedIndex = 0;
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedClass();
        });

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildClassSelector(studentNumber),
              _buildStudentList(session),
            ],
          ),
        );
      },
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
            final isMyClass = courseUnitClass.students.any(
              (student) => student.number == studentNumber,
            );
            final isSelected = index == selectedIndex;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _itemWidth,
                maxWidth: _itemWidth,
              ),
              child: GestureDetector(
                onTap: () => _handleClassTap(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.shadow.withAlpha(0x25),
                        spreadRadius: 2,
                        blurRadius: 2,
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
                    style:
                        isSelected
                            ? Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                            : Theme.of(context).textTheme.labelMedium,
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

  Widget _buildStudentList(Session session) {
    final currentClass = widget.classes[selectedIndex!];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
            session,
            key: ValueKey('${currentClass.className}_${student.number}'),
          );
        },
      ),
    );
  }
}
