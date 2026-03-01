import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:uni/controller/fetchers/book_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/modal_professor_info.dart';
import 'package:uni/view/widgets/generic_animated_expandable.dart';
import 'package:uni/view/widgets/generic_expandable.dart';
import 'package:uni_ui/cards/book_card.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/instructor_card.dart';
import 'package:uni_ui/cards/remaining_instructors_card.dart';

const double _horizontalSpacing = 8;
const double _verticalSpacing = 8;

class CourseUnitSheetView extends ConsumerStatefulWidget {
  const CourseUnitSheetView(this.courseUnitSheet, this.exams, {super.key});

  final Sheet courseUnitSheet;
  final List<Exam> exams;

  @override
  ConsumerState<CourseUnitSheetView> createState() => _CourseUnitSheetViewState();
}

class _CourseUnitSheetViewState extends ConsumerState<CourseUnitSheetView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        _buildSection(
          title: S.of(context).instructors,
          titlePadding: 20,
          content: widget.courseUnitSheet.professors.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 20),
                  child: Text(
                    S.of(context).noInstructors,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : widget.courseUnitSheet.professors.length <= 4
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 3,
                  ),
                  child: Wrap(
                    spacing: _horizontalSpacing,
                    runSpacing: _verticalSpacing,
                    children: widget.courseUnitSheet.professors
                        .map(
                          (instructor) =>
                              _InstructorCard(instructor: instructor),
                        )
                        .toList(),
                  ),
                )
              : AnimatedExpandable(
                  firstChild: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    child: _LimitedInstructorsRow(
                      instructors: widget.courseUnitSheet.professors,
                    ),
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    child: Wrap(
                      spacing: _horizontalSpacing,
                      runSpacing: _verticalSpacing,
                      children: widget.courseUnitSheet.professors
                          .map(
                            (instructor) =>
                                _InstructorCard(instructor: instructor),
                          )
                          .toList(),
                    ),
                  ),
                ),
          context: context,
        ),
        _buildSection(
          title: S.of(context).assessments,
          titlePadding: 20,
          content: widget.exams.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 20),
                  child: Text(
                    S.of(context).noExamsScheduled,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.exams.length + 2,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: _horizontalSpacing),
                    itemBuilder: (context, index) {
                      if (index == 0 || index == widget.exams.length + 1) {
                        return const SizedBox(width: 10);
                      }
                      return SizedBox(
                        width: 240,
                        child: ExamCard(
                          name: widget.exams[index - 1].subject,
                          acronym: widget.exams[index - 1].subjectAcronym,
                          rooms: widget.exams[index - 1].rooms,
                          type: widget.exams[index - 1].examType,
                          startTime: widget.exams[index - 1].startTime,
                          examDay: widget.exams[index - 1].start.day.toString(),
                          examMonth: widget.exams[index - 1].monthAcronym(
                            PreferencesController.getLocale(),
                          ),
                          showIcon: false,
                        ),
                      );
                    },
                  ),
                ),
          context: context,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSection(
            title: S.of(context).program,
            content: HtmlWidget(
              widget.courseUnitSheet.content != 'null'
                  ? widget.courseUnitSheet.content
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSection(
            title: S.of(context).evaluation,
            content: HtmlWidget(
              widget.courseUnitSheet.evaluation != 'null'
                  ? widget.courseUnitSheet.evaluation
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSection(
            title: S.of(context).frequency,
            content: HtmlWidget(
              widget.courseUnitSheet.frequency != 'null'
                  ? widget.courseUnitSheet.frequency
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
        ),
        if (widget.courseUnitSheet.books.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSection(
              title: S.of(context).bibliography,
              content: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: widget.courseUnitSheet.books.map((book) {
                    return book.isbn.isNotEmpty
                        ? FutureBuilder<String?>(
                            future: BookThumbFetcher().fetchBookThumb(
                              book.isbn,
                            ),
                            builder: (context, snapshot) {
                              return BookCard(
                                title: book.title,
                                isbn: book.isbn,
                                imageUrl: snapshot.data,
                              );
                            },
                          )
                        : BookCard(
                            title: book.title,
                            isbn: book.isbn,
                            imageUrl: null,
                          );
                  }).toList(),
                ),
              ),
              context: context,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required BuildContext context,
    double? titlePadding,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content is HtmlWidget && content.html.length > 300)
            GenericExpandable(title: title, content: content)
          else ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: titlePadding ?? 0,
                vertical: 8,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            content,
          ],
        ],
      ),
    );
  }
}

class _InstructorCard extends ConsumerWidget {
  const _InstructorCard({required this.instructor});

  final Professor instructor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider.select((value) => value.value!));
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => ProfessorInfoModal(instructor),
        );
      },
      child: Container(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
              blurRadius: 2,
            ),
          ],
        ),
        child: FutureBuilder<File?>(
          future: ProfileNotifier.fetchOrGetCachedProfilePicture(
            session,
            studentNumber: int.parse(instructor.code),
          ),
          builder: (context, snapshot) {
            final profileImage = snapshot.hasData && snapshot.data != null
                ? FileImage(snapshot.data!)
                : null;

            return InstructorCard(
              name: instructor.name,
              isRegent: instructor.isRegent,
              instructorLabel: S.of(context).instructor,
              regentLabel: S.of(context).courseRegent,
              profileImage: profileImage,
            );
          },
        ),
      ),
    );
  }
}

class _LimitedInstructorsRow extends ConsumerWidget {
  const _LimitedInstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstThree = instructors.take(3).toList();
    final remaining = instructors.skip(3).toList();
    final remainingToShow = remaining.take(3).toList();
    final session = ref.read(sessionProvider.select((value) => value.value!));

    return Wrap(
      spacing: _horizontalSpacing,
      runSpacing: _verticalSpacing,
      children: [
        ...firstThree.map(
          (instructor) => _InstructorCard(instructor: instructor),
        ),
        if (remaining.isNotEmpty)
          FutureBuilder<List<File?>>(
            future: Future.wait(
              remainingToShow.map(
                (instructor) => ProfileNotifier.fetchOrGetCachedProfilePicture(
                  session,
                  studentNumber: int.parse(instructor.code),
                ),
              ),
            ),
            builder: (context, snapshot) {
              final images =
                  snapshot.data
                      ?.map(
                        (file) => file != null
                            ? FileImage(file) as ImageProvider
                            : null,
                      )
                      .toList() ??
                  List.filled(remainingToShow.length, null);

              return RemainingInstructorsCard(
                remainingCount: remaining.length,
                profileImages: images,
                tooltip: S.of(context).remaining_instructors,
              );
            },
          ),
      ],
    );
  }
}
