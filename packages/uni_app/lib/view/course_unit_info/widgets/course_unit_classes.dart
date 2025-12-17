import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/student_number_getter.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_student_tile.dart';
import 'package:uni/view/course_unit_info/widgets/modal_professor_info.dart';
import 'package:uni_ui/cards/instructor_card.dart';

class CourseUnitClassesView extends ConsumerStatefulWidget {
  const CourseUnitClassesView(
    this.classes,
    this.professors,
    this.courseUnit, {
    this.classProfessors = const <String, List<Professor>>{},
    super.key,
  });

  final List<CourseUnitClass> classes;
  final List<Professor> professors;
  final CourseUnit courseUnit;
  final Map<String, List<Professor>> classProfessors;

  @override
  ConsumerState<CourseUnitClassesView> createState() =>
      _CourseUnitClassesViewState();
}

class _CourseUnitClassesViewState extends ConsumerState<CourseUnitClassesView> {
  static const double _itemWidth = 140;
  static const double _edgeSpacing = 14;
  static const _scrollDuration = Duration(milliseconds: 300);

  final _scrollController = ScrollController();

  int? selectedIndex;
  late int studentNumber;

  void _scrollToSelectedClass() {
    if (selectedIndex == null || widget.classes.isEmpty) {
      return;
    }
    if (!_scrollController.hasClients) {
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    var offset =
        _edgeSpacing +
        (_itemWidth * selectedIndex!) -
        (screenWidth - _itemWidth) / 2;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (offset < 0) {
      offset = 0;
    }
    if (offset > maxScroll) {
      offset = maxScroll;
    }

    _scrollController.animateTo(
      offset,
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
              _buildClassProfessor(),
              _buildStudentList(session),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassSelector(int studentNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: SizedBox(
        height: 55,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.classes.length + 2,
          itemBuilder: (context, index) {
            if (index == 0 || index == widget.classes.length + 1) {
              return const SizedBox(width: _edgeSpacing);
            }
            final classIndex = index - 1;
            final courseUnitClass = widget.classes[classIndex];
            final isMyClass = courseUnitClass.students.any(
              (student) => student.number == studentNumber,
            );
            final isSelected = classIndex == selectedIndex;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _itemWidth,
                maxWidth: _itemWidth,
              ),
              child: GestureDetector(
                onTap: () => _handleClassTap(classIndex),
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

  Widget _buildClassProfessor() {
    final currentClass = widget.classes[selectedIndex!];
    final professors = widget.classProfessors[currentClass.className];

    if (professors == null || professors.isEmpty) {
      return const SizedBox.shrink();
    }

    final session = ref.read(sessionProvider).value!;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            professors.map((professor) {
              return GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ProfessorInfoModal(professor),
                  );
                },

                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.shadow.withAlpha(0x25),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: FutureBuilder<File?>(
                    future: ProfileNotifier.fetchOrGetCachedProfilePicture(
                      session,
                      studentNumber: int.parse(professor.code),
                    ),
                    builder: (context, snapshot) {
                      final profileImage =
                          snapshot.hasData && snapshot.data != null
                              ? FileImage(snapshot.data!)
                              : null;

                      return InstructorCard(
                        name: professor.name,
                        isRegent: professor.isRegent,
                        instructorLabel: S.of(context).classProfessor,
                        regentLabel: S.of(context).classProfessor,
                        profileImage: profileImage,
                      );
                    },
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildStudentList(Session session) {
    final currentClass = widget.classes[selectedIndex!];

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
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
