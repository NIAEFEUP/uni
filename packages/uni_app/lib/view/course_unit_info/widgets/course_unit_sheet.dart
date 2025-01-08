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
import 'package:uni_ui/cards/exam_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  const CourseUnitSheetView(this.courseUnitSheet, this.exams, {super.key});

  final Sheet courseUnitSheet;
  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructorsSection(context, courseUnitSheet.professors),
            _buildAssessmentsSection(context, exams),
            _buildContentCard(
              S.of(context).program,
              courseUnitSheet.content,
              context,
            ),
            _buildContentCard(
              S.of(context).evaluation,
              courseUnitSheet.evaluation,
              context,
            ),
            _buildContentCard(
              S.of(context).frequency,
              courseUnitSheet.frequency,
              context,
            ),
            if (courseUnitSheet.books.isNotEmpty) ...[
              Text(
                S.of(context).bibliography,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              _buildBooksRow(context, courseUnitSheet.books),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorsSection(
    BuildContext context,
    List<Professor> instructors,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            S.of(context).instructors,
            style: textTheme.headlineLarge,
          ),
        ),
        if (instructors.length <= 4)
          _InstructorsRow(instructors: instructors)
        else
          AnimatedExpandable(
            firstChild: _LimitedInstructorsRow(instructors: instructors),
            secondChild: _InstructorsRow(instructors: instructors),
          ),
      ],
    );
  }

  Widget _buildAssessmentsSection(BuildContext context, List<Exam> exams) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            S.of(context).assessments,
            style: textTheme.headlineLarge,
          ),
        ),
        if (exams.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              S.of(context).noExamsScheduled,
              style: textTheme.bodyLarge,
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: exams.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) =>
                  _buildExamCard(context, exams[index]),
            ),
          ),
        _addDivider(),
      ],
    );
  }

  Widget _buildExamCard(BuildContext context, Exam exam) {
    return SizedBox(
      width: 240,
      child: ExamCard(
        name: exam.subject,
        acronym: exam.subjectAcronym,
        rooms: exam.rooms,
        type: exam.examType,
        startTime: exam.startTime,
        examDay: exam.start.day.toString(),
        examMonth: exam.monthAcronym(PreferencesController.getLocale()),
        showIcon: false,
      ),
    );
  }

  Widget _buildBooksRow(BuildContext context, List<Book> books) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: books.map((book) => _buildBookTile(context, book)).toList(),
    );
  }

  Widget _buildBookTile(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          SizedBox(
            width: 135,
            height: 140,
            child: book.isbn.isNotEmpty
                ? FutureBuilder<String?>(
                    future: BookThumbFetcher().fetchBookThumb(book.isbn),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Image(image: NetworkImage(snapshot.data!));
                      } else {
                        return const Image(
                          image: AssetImage(
                            'assets/images/book_placeholder.png',
                          ),
                        );
                      }
                    },
                  )
                : const Image(
                    image: AssetImage(
                      'assets/images/book_placeholder.png',
                    ),
                  ),
          ),
          SizedBox(
            width: 135,
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(
    String sectionTitle,
    String sectionContent,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          GenericExpandable(
            title: sectionTitle,
            content: HtmlWidget(
              sectionContent != 'null' ? sectionContent : S.of(context).no_info,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          _addDivider(),
        ],
      ),
    );
  }
}

Widget _addDivider() {
  return const Opacity(
    opacity: 0.25,
    child: Divider(color: Colors.grey),
  );
}

class _LimitedInstructorsRow extends StatelessWidget {
  const _LimitedInstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstThree = instructors.take(3).toList();
    final remaining = instructors.skip(3).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        ...firstThree
            .map((instructor) => _InstructorChip(instructor: instructor)),
        if (remaining.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 245, 243, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 70,
                  height: 40,
                  child: Stack(
                    children: remaining.asMap().entries.map((entry) {
                      final index = entry.key;
                      final instructor = entry.value;
                      return Positioned(
                        left: index * 20.0,
                        child: _InstructorAvatar(instructor: instructor),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  S.of(context).moreInstructors(remaining.length),
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InstructorsRow extends StatelessWidget {
  const _InstructorsRow({required this.instructors});

  final List<Professor> instructors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: instructors
          .map((instructor) => _InstructorChip(instructor: instructor))
          .toList(),
    );
  }
}

class _InstructorChip extends StatelessWidget {
  const _InstructorChip({required this.instructor});

  final Professor instructor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => ProfessorInfoModal(instructor),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 245, 243, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InstructorAvatar(instructor: instructor),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    instructor.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  instructor.isRegent
                      ? S.of(context).courseRegent
                      : S.of(context).instructor,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructorAvatar extends StatelessWidget {
  const _InstructorAvatar({required this.instructor});

  final Professor instructor;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context, listen: false).state!;
    return FutureBuilder<File?>(
      future: ProfileProvider.fetchOrGetCachedProfilePicture(
        session,
        studentNumber: int.parse(instructor.code),
      ),
      builder: (context, snapshot) => CircleAvatar(
        radius: 20,
        backgroundImage: snapshot.hasData && snapshot.data != null
            ? FileImage(snapshot.data!) as ImageProvider
            : const AssetImage('assets/images/profile_placeholder.png'),
      ),
    );
  }
}
