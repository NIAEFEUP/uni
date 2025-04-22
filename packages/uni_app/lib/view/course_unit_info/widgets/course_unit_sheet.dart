import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/fetchers/book_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/generic_animated_expandable.dart';
import 'package:uni/view/common_widgets/generic_expandable.dart';
import 'package:uni/view/course_unit_info/widgets/modal_professor_info.dart';
import 'package:uni_ui/cards/book_card.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/instructor_card.dart';
import 'package:uni_ui/cards/remaining_instructors_card.dart';

const double _horizontalSpacing = 8;
const double _verticalSpacing = 4;

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, this.exams, {super.key});

  final Sheet courseUnitSheet;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          _buildSection(
            title: S.of(context).instructors,
            content: courseUnitSheet.professors.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      S.of(context).noInstructors,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : courseUnitSheet.professors.length <= 4
                    ? Wrap(
                        spacing: _horizontalSpacing,
                        runSpacing: _verticalSpacing,
                        children: courseUnitSheet.professors
                            .map(
                              (instructor) =>
                                  _InstructorCard(instructor: instructor),
                            )
                            .toList(),
                      )
                    : AnimatedExpandable(
                        firstChild: _LimitedInstructorsRow(
                          instructors: courseUnitSheet.professors,
                        ),
                        secondChild: Wrap(
                          spacing: _horizontalSpacing,
                          runSpacing: _verticalSpacing,
                          children: courseUnitSheet.professors
                              .map(
                                (instructor) =>
                                    _InstructorCard(instructor: instructor),
                              )
                              .toList(),
                        ),
                      ),
            context: context,
          ),
          _buildSection(
            title: S.of(context).assessments,
            content: exams.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      S.of(context).noExamsScheduled,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: exams.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: _horizontalSpacing),
                      itemBuilder: (context, index) => SizedBox(
                        width: 240,
                        child: ExamCard(
                          name: exams[index].subject,
                          acronym: exams[index].subjectAcronym,
                          rooms: exams[index].rooms,
                          type: exams[index].examType,
                          startTime: exams[index].startTime,
                          examDay: exams[index].start.day.toString(),
                          examMonth: exams[index]
                              .monthAcronym(PreferencesController.getLocale()),
                          showIcon: false,
                        ),
                      ),
                    ),
                  ),
            context: context,
          ),
          _buildSection(
            title: S.of(context).program,
            content: HtmlWidget(
              courseUnitSheet.content != 'null'
                  ? courseUnitSheet.content
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
          _buildSection(
            title: S.of(context).evaluation,
            content: HtmlWidget(
              courseUnitSheet.evaluation != 'null'
                  ? courseUnitSheet.evaluation
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
          _buildSection(
            title: S.of(context).frequency,
            content: HtmlWidget(
              courseUnitSheet.frequency != 'null'
                  ? courseUnitSheet.frequency
                  : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            context: context,
          ),
          if (courseUnitSheet.books.isNotEmpty)
            _buildSection(
              title: S.of(context).bibliography,
              content: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: courseUnitSheet.books.map((book) {
                    return book.isbn.isNotEmpty
                        ? FutureBuilder<String?>(
                            future:
                                BookThumbFetcher().fetchBookThumb(book.isbn),
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
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content is HtmlWidget && content.html.length > 300)
            GenericExpandable(
              title: title,
              content: content,
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(
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

class _InstructorCard extends StatelessWidget {
  const _InstructorCard({required this.instructor});

  final Professor instructor;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().state!;
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => ProfessorInfoModal(instructor),
        );
      },
      child: FutureBuilder<File?>(
        future: ProfileProvider.fetchOrGetCachedProfilePicture(
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
    );
  }
}

class _LimitedInstructorsRow extends StatelessWidget {
  const _LimitedInstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context) {
    final firstThree = instructors.take(3).toList();
    final remaining = instructors.skip(3).toList();
    final remainingToShow = remaining.take(3).toList();
    final session = context.read<SessionProvider>().state!;

    return Wrap(
      spacing: _horizontalSpacing,
      runSpacing: _verticalSpacing,
      children: [
        ...firstThree
            .map((instructor) => _InstructorCard(instructor: instructor)),
        if (remaining.isNotEmpty)
          FutureBuilder<List<File?>>(
            future: Future.wait(
              remainingToShow.map(
                (instructor) => ProfileProvider.fetchOrGetCachedProfilePicture(
                  session,
                  studentNumber: int.parse(instructor.code),
                ),
              ),
            ),
            builder: (context, snapshot) {
              final images = snapshot.data
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
